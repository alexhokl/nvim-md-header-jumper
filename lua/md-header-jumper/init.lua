local M = {}

local function goto_node(node)
	local row, col = node:start()
	vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

local function header_query(level)
	if level then
		return string.format("((atx_heading (atx_h%d_marker)) @header)", level)
	end
	return "((atx_heading) @header)"
end

function M.goto_next_header(level)
	local query = vim.treesitter.query.parse("markdown", header_query(level))
	local root = vim.treesitter.get_parser():parse()[1]:root()
	local _, node, _ = query:iter_captures(root, 0, vim.fn.line("."), -1)()

	if node then
		goto_node(node)
	end
end

function M.goto_prev_header(level)
	local query = vim.treesitter.query.parse("markdown", header_query(level))
	local root = vim.treesitter.get_parser():parse()[1]:root()

	if vim.fn.line(".") == 1 then
		return
	end

	local node
	for _, n, _ in query:iter_captures(root, 0, 0, vim.fn.line(".") - 1) do
		node = n
	end

	if node then
		goto_node(node)
	end
end

for level = 1, 6 do
	M["goto_next_h" .. level] = function()
		M.goto_next_header(level)
	end
	M["goto_prev_h" .. level] = function()
		M.goto_prev_header(level)
	end
end

local function map_keys(bufnr, opts)
	if opts.next_key then
		vim.keymap.set("n", opts.next_key, M.goto_next_header, {
			desc = "Go to next header",
			buffer = bufnr,
		})
	end
	if opts.prev_key then
		vim.keymap.set("n", opts.prev_key, M.goto_prev_header, {
			desc = "Go to previous header",
			buffer = bufnr,
		})
	end

	for level = 1, 6 do
		local next_key = opts["next_h" .. level .. "_key"]
		if next_key then
			vim.keymap.set("n", next_key, M["goto_next_h" .. level], {
				desc = "Go to next h" .. level .. " header",
				buffer = bufnr,
			})
		end

		local prev_key = opts["prev_h" .. level .. "_key"]
		if prev_key then
			vim.keymap.set("n", prev_key, M["goto_prev_h" .. level], {
				desc = "Go to previous h" .. level .. " header",
				buffer = bufnr,
			})
		end
	end
end

function M.setup(opts)
	local defaults = {
		next_key = "]hh",
		prev_key = "[hh",
	}
	for level = 1, 6 do
		defaults["next_h" .. level .. "_key"] = "]h" .. level
		defaults["prev_h" .. level .. "_key"] = "[h" .. level
	end

	opts = vim.tbl_deep_extend("keep", opts or {}, defaults)

	local group = vim.api.nvim_create_augroup("md-header-jumper", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "markdown",
		callback = function(args)
			map_keys(args.buf, opts)
		end,
	})

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].filetype == "markdown" and vim.api.nvim_buf_is_loaded(buf) then
			map_keys(buf, opts)
		end
	end

	vim.api.nvim_create_user_command("MdHeaderNext", function()
		M.goto_next_header()
	end, {
		desc = "Go to next markdown header",
	})
	vim.api.nvim_create_user_command("MdHeaderPrev", function()
		M.goto_prev_header()
	end, {
		desc = "Go to previous markdown header",
	})

	for level = 1, 6 do
		vim.api.nvim_create_user_command("MdHeaderNextH" .. level, M["goto_next_h" .. level], {
			desc = "Go to next h" .. level .. " markdown header",
		})
		vim.api.nvim_create_user_command("MdHeaderPrevH" .. level, M["goto_prev_h" .. level], {
			desc = "Go to previous h" .. level .. " markdown header",
		})
	end
end

return M
