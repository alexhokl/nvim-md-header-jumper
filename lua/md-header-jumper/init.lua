local M = {}

local function goto_node(node)
	local row, col = node:start()
	vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

function M.goto_next_header()
	local query = vim.treesitter.query.parse("markdown", "((atx_heading) @header)")
	local root = vim.treesitter.get_parser():parse()[1]:root()
	local _, node, _ = query:iter_captures(root, 0, vim.fn.line("."), -1)()

	if node then
		goto_node(node)
	end
end

function M.goto_prev_header()
	local query = vim.treesitter.query.parse("markdown", "((atx_heading) @header)")
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
end

function M.setup(opts)
	opts = vim.tbl_deep_extend("keep", opts or {}, {
		next_key = "]h",
		prev_key = "[h",
	})

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

	vim.api.nvim_create_user_command("MdHeaderNext", M.goto_next_header, {
		desc = "Go to next markdown header",
	})
	vim.api.nvim_create_user_command("MdHeaderPrev", M.goto_prev_header, {
		desc = "Go to previous markdown header",
	})
end

return M
