local packer = nil

if packer == nil then
    packer = require 'packer'
packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end,
    prompt_border = 'single',
  },
  git = {
    clone_timeout = 800, -- Timeout, in seconds, for git clones
  },
  compile_path = vim.fn.stdpath('config') .. '/lua/compiled.lua',
  auto_clean = true,
  compile_on_sync = true,
})
  end

-- @todo this does not work...
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end


return require('packer').startup(function(use)

    use 'wbthomason/packer.nvim'

    -- This will be removed once https://github.com/neovim/neovim/pull/15436 is merged - so keep an eye on it
    use({
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end,
  })

  use('nathom/filetype.nvim')

  use({ -- icons
    'kyazdani42/nvim-web-devicons',
    after = 'tokyonight.nvim',
  })

    use({ -- color scheme
    'folke/tokyonight.nvim',
    config = function()
      vim.g.tokyonight_style = 'night'
      vim.g.tokyonight_sidebars = { 'qf' }
      vim.cmd('color tokyonight')
    end,
  })

  use {
  'nvim-lualine/lualine.nvim',
  requires = {'kyazdani42/nvim-web-devicons', opt = true},
  config = function()
      require('lualine').setup({
          options = { theme = 'tokyonight' }
      })
  end,
  after = 'nvim-web-devicons',
}

 -- file explorer
  use({
    'kyazdani42/nvim-tree.lua',
    config = function()
        -- Coming back to this @todo
      -- require('cosmic.core.file-explorer')
    end,
    opt = true,
    cmd = {
      'NvimTreeClipboard',
      'NvimTreeClose',
      'NvimTreeFindFile',
      'NvimTreeOpen',
      'NvimTreeRefresh',
      'NvimTreeToggle',
    },
  })


    -- @todo still need to write config for this, see: https://github.com/numToStr/Comment.nvim
    -- Additionally check this out: https://www.reddit.com/r/neovim/comments/q35328/commentnvim_simple_and_powerful_comment_plugin/
    -- and this: https://github.com/JoosepAlviste/nvim-ts-context-commentstring
  use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
