;; extends
(macro_invocation
  (scoped_identifier
    name: (identifier) @_name (#eq? @_name "query_as"))
  (token_tree
    (raw_string_literal) @sql)

  (#offset! @sql 1 0 0 0)
)
    
