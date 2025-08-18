; extends

; Inject TypeScript for import statements
((inline) @injection.content
  (#lua-match? @injection.content "^%s*import")
  (#set! injection.language "typescript"))

; Inject TypeScript for export statements  
((inline) @injection.content
  (#lua-match? @injection.content "^%s*export")
  (#set! injection.language "typescript"))

; Inject JSX for JSX elements
((html_block) @injection.content
  (#set! injection.language "jsx"))

; Inject JavaScript for inline code blocks with js/javascript
((fenced_code_block
  (info_string) @_lang
  (code_fence_content) @injection.content)
  (#match? @_lang "^(js|javascript)$")
  (#set! injection.language "javascript"))

; Inject TypeScript for inline code blocks with ts/typescript
((fenced_code_block
  (info_string) @_lang
  (code_fence_content) @injection.content)
  (#match? @_lang "^(ts|typescript)$")
  (#set! injection.language "typescript"))

; Inject JSX for inline code blocks with jsx
((fenced_code_block
  (info_string) @_lang
  (code_fence_content) @injection.content)
  (#match? @_lang "^jsx$")
  (#set! injection.language "jsx"))

; Inject TSX for inline code blocks with tsx
((fenced_code_block
  (info_string) @_lang
  (code_fence_content) @injection.content)
  (#match? @_lang "^tsx$")
  (#set! injection.language "tsx"))