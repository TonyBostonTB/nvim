-- Ansible YAML filetype detection
-- Detects Ansible files based on directory structure patterns
vim.filetype.add({
  pattern = {
    ['.*/tasks/.*.yml'] = 'yaml.ansible',
    ['.*/defaults/.*.yml'] = 'yaml.ansible', 
    ['.*/handlers/.*.yml'] = 'yaml.ansible',
    ['.*/main/.*.yml'] = 'yaml.ansible',
    ['.*/vars/.*.yml'] = 'yaml.ansible',
    ['.*/playbooks/.*.yml'] = 'yaml.ansible',
  }
})