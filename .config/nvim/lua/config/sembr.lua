local M = {}

local protected_types = {
	code_span = true,
	inline_link = true,
	full_reference_link = true,
	collapsed_reference_link = true,
	shortcut_link = true,
	image = true,
	uri_autolink = true,
	email_autolink = true,
	html_tag = true,
	latex_block = true,
}

local abbreviations = {
	["e.g."] = true,
	["i.e."] = true,
	["vs."] = true,
	["cf."] = true,
	["mr."] = true,
	["mrs."] = true,
	["dr."] = true,
}

local sentence_end = "()[.!?][)\"'*_]*()[ \t]+()[^%s%l]"

local function collect_nodes(lines)
	local parser = vim.treesitter.get_string_parser(table.concat(lines, "\n"), "markdown")
	parser:parse(true)

	local paragraphs, protected = {}, {}
	parser:for_each_tree(function(tree, ltree)
		local lang = ltree:lang()
		local function walk(node)
			local type = node:type()
			if lang == "markdown" and type == "paragraph" then
				table.insert(paragraphs, { node:range() })
			elseif lang == "markdown_inline" and protected_types[type] then
				table.insert(protected, { node:range() })
				return
			end
			for child in node:iter_children() do
				walk(child)
			end
		end
		walk(tree:root())
	end)
	return paragraphs, protected
end

local function before(row_a, col_a, row_b, col_b)
	return row_a < row_b or (row_a == row_b and col_a < col_b)
end

local function is_protected(protected, row, col)
	for _, range in ipairs(protected) do
		local sr, sc, er, ec = unpack(range)
		if not before(row, col, sr, sc) and before(row, col, er, ec) then
			return true
		end
	end
	return false
end

local function is_abbreviation(line, punct)
	local word = line:sub(1, punct):match("(%S+)$")
	return word and abbreviations[word:lower()]
end

local function find_breaks(line, row, first_col, protected)
	local breaks = {}
	local init = first_col + 1
	while true do
		local _, _, punct, gap, next_word = line:find(sentence_end, init)
		if not punct then
			return breaks
		end
		if not is_protected(protected, row, punct - 1) and not is_abbreviation(line, punct) then
			table.insert(breaks, { gap = gap, next_word = next_word })
		end
		init = next_word
	end
end

local function split_line(line, breaks, prefix)
	local parts = {}
	local start = 1
	for _, b in ipairs(breaks) do
		table.insert(parts, line:sub(start, b.gap - 1))
		start = b.next_word
	end
	table.insert(parts, line:sub(start))
	for i = 2, #parts do
		parts[i] = prefix .. parts[i]
	end
	return parts
end

function M.format(lines)
	local paragraphs, protected = collect_nodes(lines)
	local breaks_by_row, prefix_by_row = {}, {}

	for _, range in ipairs(paragraphs) do
		local sr, sc, er, ec = unpack(range)
		if ec == 0 then
			er = er - 1
		end
		-- List markers become spaces so new lines stay inside the list item; ">" is kept for blockquotes.
		local prefix = lines[sr + 1]:sub(1, sc):gsub("[^>%s]", " ")
		for row = sr, er do
			breaks_by_row[row] = find_breaks(lines[row + 1], row, row == sr and sc or 0, protected)
			prefix_by_row[row] = prefix
		end
	end

	local result = {}
	for i, line in ipairs(lines) do
		local row = i - 1
		local breaks = breaks_by_row[row]
		if breaks and #breaks > 0 then
			vim.list_extend(result, split_line(line, breaks, prefix_by_row[row]))
		else
			table.insert(result, line)
		end
	end
	return result
end

return M
