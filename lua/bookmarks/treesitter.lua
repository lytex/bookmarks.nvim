
local data = require("bookmarks.data")
local api = vim.api

local function fix_bookmarks()
    local rows = vim.fn.line("$")
    local filename = api.nvim_buf_get_name(0)

    -- find bookmarks
    if data.bookmarks_groupby_filename[filename] == nil then
        return
    end

    for _, id in pairs(data.bookmarks_groupby_filename[filename]) do
        local b = data.bookmarks[id]
        if b == nil then
            return
        end

        if b.query == nil then
            goto continue
        end

        local query = vim.treesitter.query.parse('lua', b.query)

        local tree = vim.treesitter.get_parser():parse()[1]:root()

         for pattern, match, metadata in query:iter_matches(tree:root(), 0, 0, -1) do
           for id, node in pairs(match) do
             -- local name = query.captures[id]
             -- `node` was captured by the `name` capture in the match

             -- local node_data = metadata[id] -- Node level metadata

            -- :range
            -- - start row
            -- - start column
            -- - start byte (if {include_bytes} is `true`)
            -- - end row
            -- - end column
            -- - end byte (if {include_bytes} is `true`)
             -- print_kv(node)
             print(node:range())
             print(node:type())
             -- vim.inspect(node)

             -- ... use the info here ...
           end
         end

        ::continue::
    end
end

return {
    fix_bookmarks = fix_bookmarks
}
