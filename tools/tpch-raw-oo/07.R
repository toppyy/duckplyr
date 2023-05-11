load("tools/tpch/001.rda")
con <- DBI::dbConnect(duckdb::duckdb())
experimental <- FALSE
invisible(DBI::dbExecute(con, "CREATE MACRO \"|\"(x, y) AS (x OR y)"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"==\"(a, b) AS a = b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \">=\"(a, b) AS a >= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"as.Date\"(x) AS strptime(x, '%Y-%m-%d')"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"<=\"(a, b) AS a <= b"))
invisible(DBI::dbExecute(con, "CREATE MACRO \"&\"(x, y) AS (x AND y)"))
df1 <- supplier
rel1 <- duckdb:::rel_from_df(con, df1, experimental = experimental)
rel2 <- duckdb:::rel_project(
  rel1,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    }
  )
)
df2 <- nation
rel3 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel4 <- duckdb:::rel_project(
  rel3,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
rel5 <- duckdb:::rel_filter(
  rel4,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n1_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("FRANCE", experimental = experimental)
            } else {
              duckdb:::expr_constant("FRANCE")
            }
          )
        ),
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n1_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("GERMANY", experimental = experimental)
            } else {
              duckdb:::expr_constant("GERMANY")
            }
          )
        )
      )
    )
  )
)
rel6 <- duckdb:::rel_set_alias(rel2, "lhs")
rel7 <- duckdb:::rel_set_alias(rel5, "rhs")
rel8 <- duckdb:::rel_project(
  rel6,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel9 <- duckdb:::rel_project(
  rel7,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n1_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n1_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel10 <- duckdb:::rel_join(
  rel8,
  rel9,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("s_nationkey", rel8), duckdb:::expr_reference("n1_nationkey", rel9))
    )
  ),
  "inner"
)
rel11 <- duckdb:::rel_order(
  rel10,
  list(duckdb:::expr_reference("___row_number_x", rel8), duckdb:::expr_reference("___row_number_y", rel9))
)
rel12 <- duckdb:::rel_project(
  rel11,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "s_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
rel13 <- duckdb:::rel_project(
  rel12,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
df3 <- customer
rel14 <- duckdb:::rel_from_df(con, df3, experimental = experimental)
rel15 <- duckdb:::rel_project(
  rel14,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    }
  )
)
rel16 <- duckdb:::rel_from_df(con, df2, experimental = experimental)
rel17 <- duckdb:::rel_project(
  rel16,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel18 <- duckdb:::rel_filter(
  rel17,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n2_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("FRANCE", experimental = experimental)
            } else {
              duckdb:::expr_constant("FRANCE")
            }
          )
        ),
        duckdb:::expr_function(
          "==",
          list(
            duckdb:::expr_reference("n2_name"),
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("GERMANY", experimental = experimental)
            } else {
              duckdb:::expr_constant("GERMANY")
            }
          )
        )
      )
    )
  )
)
rel19 <- duckdb:::rel_set_alias(rel15, "lhs")
rel20 <- duckdb:::rel_set_alias(rel18, "rhs")
rel21 <- duckdb:::rel_project(
  rel19,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel22 <- duckdb:::rel_project(
  rel20,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("n2_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "n2_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel23 <- duckdb:::rel_join(
  rel21,
  rel22,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("c_nationkey", rel21), duckdb:::expr_reference("n2_nationkey", rel22))
    )
  ),
  "inner"
)
rel24 <- duckdb:::rel_order(
  rel23,
  list(duckdb:::expr_reference("___row_number_x", rel21), duckdb:::expr_reference("___row_number_y", rel22))
)
rel25 <- duckdb:::rel_project(
  rel24,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("c_nationkey")
      duckdb:::expr_set_alias(tmp_expr, "c_nationkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel26 <- duckdb:::rel_project(
  rel25,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
df4 <- orders
rel27 <- duckdb:::rel_from_df(con, df4, experimental = experimental)
rel28 <- duckdb:::rel_project(
  rel27,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    }
  )
)
rel29 <- duckdb:::rel_set_alias(rel28, "lhs")
rel30 <- duckdb:::rel_set_alias(rel26, "rhs")
rel31 <- duckdb:::rel_project(
  rel29,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel32 <- duckdb:::rel_project(
  rel30,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("c_custkey")
      duckdb:::expr_set_alias(tmp_expr, "c_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel33 <- duckdb:::rel_join(
  rel31,
  rel32,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("o_custkey", rel31), duckdb:::expr_reference("c_custkey", rel32))
    )
  ),
  "inner"
)
rel34 <- duckdb:::rel_order(
  rel33,
  list(duckdb:::expr_reference("___row_number_x", rel31), duckdb:::expr_reference("___row_number_y", rel32))
)
rel35 <- duckdb:::rel_project(
  rel34,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_custkey")
      duckdb:::expr_set_alias(tmp_expr, "o_custkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel36 <- duckdb:::rel_project(
  rel35,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
df5 <- lineitem
rel37 <- duckdb:::rel_from_df(con, df5, experimental = experimental)
rel38 <- duckdb:::rel_project(
  rel37,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    }
  )
)
rel39 <- duckdb:::rel_filter(
  rel38,
  list(
    duckdb:::expr_function(
      ">=",
      list(
        duckdb:::expr_reference("l_shipdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1995-01-01", experimental = experimental)
            } else {
              duckdb:::expr_constant("1995-01-01")
            }
          )
        )
      )
    ),
    duckdb:::expr_function(
      "<=",
      list(
        duckdb:::expr_reference("l_shipdate"),
        duckdb:::expr_function(
          "as.Date",
          list(
            if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
              duckdb:::expr_constant("1996-12-31", experimental = experimental)
            } else {
              duckdb:::expr_constant("1996-12-31")
            }
          )
        )
      )
    )
  )
)
rel40 <- duckdb:::rel_set_alias(rel39, "lhs")
rel41 <- duckdb:::rel_set_alias(rel36, "rhs")
rel42 <- duckdb:::rel_project(
  rel40,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel43 <- duckdb:::rel_project(
  rel41,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("o_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "o_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel44 <- duckdb:::rel_join(
  rel42,
  rel43,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_orderkey", rel42), duckdb:::expr_reference("o_orderkey", rel43))
    )
  ),
  "inner"
)
rel45 <- duckdb:::rel_order(
  rel44,
  list(duckdb:::expr_reference("___row_number_x", rel42), duckdb:::expr_reference("___row_number_y", rel43))
)
rel46 <- duckdb:::rel_project(
  rel45,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_orderkey")
      duckdb:::expr_set_alias(tmp_expr, "l_orderkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel47 <- duckdb:::rel_project(
  rel46,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    }
  )
)
rel48 <- duckdb:::rel_set_alias(rel47, "lhs")
rel49 <- duckdb:::rel_set_alias(rel13, "rhs")
rel50 <- duckdb:::rel_project(
  rel48,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_x")
      tmp_expr
    }
  )
)
rel51 <- duckdb:::rel_project(
  rel49,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("s_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "s_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_window(duckdb:::expr_function("row_number", list()), list(), list(), offset_expr = NULL, default_expr = NULL)
      duckdb:::expr_set_alias(tmp_expr, "___row_number_y")
      tmp_expr
    }
  )
)
rel52 <- duckdb:::rel_join(
  rel50,
  rel51,
  list(
    duckdb:::expr_function(
      "==",
      list(duckdb:::expr_reference("l_suppkey", rel50), duckdb:::expr_reference("s_suppkey", rel51))
    )
  ),
  "inner"
)
rel53 <- duckdb:::rel_order(
  rel52,
  list(duckdb:::expr_reference("___row_number_x", rel50), duckdb:::expr_reference("___row_number_y", rel51))
)
rel54 <- duckdb:::rel_project(
  rel53,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    }
  )
)
rel55 <- duckdb:::rel_filter(
  rel54,
  list(
    duckdb:::expr_function(
      "|",
      list(
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n1_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("FRANCE", experimental = experimental)
                } else {
                  duckdb:::expr_constant("FRANCE")
                }
              )
            ),
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n2_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("GERMANY", experimental = experimental)
                } else {
                  duckdb:::expr_constant("GERMANY")
                }
              )
            )
          )
        ),
        duckdb:::expr_function(
          "&",
          list(
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n1_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("GERMANY", experimental = experimental)
                } else {
                  duckdb:::expr_constant("GERMANY")
                }
              )
            ),
            duckdb:::expr_function(
              "==",
              list(
                duckdb:::expr_reference("n2_name"),
                if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                  duckdb:::expr_constant("FRANCE", experimental = experimental)
                } else {
                  duckdb:::expr_constant("FRANCE")
                }
              )
            )
          )
        )
      )
    )
  )
)
rel56 <- duckdb:::rel_project(
  rel55,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    }
  )
)
rel57 <- duckdb:::rel_project(
  rel56,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    }
  )
)
rel58 <- duckdb:::rel_project(
  rel57,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function("year", list(duckdb:::expr_reference("l_shipdate")))
      duckdb:::expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    }
  )
)
rel59 <- duckdb:::rel_project(
  rel58,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("l_suppkey")
      duckdb:::expr_set_alias(tmp_expr, "l_suppkey")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_shipdate")
      duckdb:::expr_set_alias(tmp_expr, "l_shipdate")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_extendedprice")
      duckdb:::expr_set_alias(tmp_expr, "l_extendedprice")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_discount")
      duckdb:::expr_set_alias(tmp_expr, "l_discount")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n2_name")
      duckdb:::expr_set_alias(tmp_expr, "n2_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("n1_name")
      duckdb:::expr_set_alias(tmp_expr, "n1_name")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_year")
      duckdb:::expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_function(
        "*",
        list(
          duckdb:::expr_reference("l_extendedprice"),
          duckdb:::expr_function(
            "-",
            list(
              if ("experimental" %in% names(formals(duckdb:::expr_constant))) {
                duckdb:::expr_constant(1, experimental = experimental)
              } else {
                duckdb:::expr_constant(1)
              },
              duckdb:::expr_reference("l_discount")
            )
          )
        )
      )
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel60 <- duckdb:::rel_project(
  rel59,
  list(
    {
      tmp_expr <- duckdb:::expr_reference("supp_nation")
      duckdb:::expr_set_alias(tmp_expr, "supp_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("cust_nation")
      duckdb:::expr_set_alias(tmp_expr, "cust_nation")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("l_year")
      duckdb:::expr_set_alias(tmp_expr, "l_year")
      tmp_expr
    },
    {
      tmp_expr <- duckdb:::expr_reference("volume")
      duckdb:::expr_set_alias(tmp_expr, "volume")
      tmp_expr
    }
  )
)
rel61 <- duckdb:::rel_aggregate(
  rel60,
  groups = list(duckdb:::expr_reference("supp_nation"), duckdb:::expr_reference("cust_nation"), duckdb:::expr_reference("l_year")),
  aggregates = list({
    tmp_expr <- duckdb:::expr_function("sum", list(duckdb:::expr_reference("volume")))
    duckdb:::expr_set_alias(tmp_expr, "revenue")
    tmp_expr
  })
)
rel62 <- duckdb:::rel_order(
  rel61,
  list(duckdb:::expr_reference("supp_nation"), duckdb:::expr_reference("cust_nation"), duckdb:::expr_reference("l_year"))
)
rel62
duckdb:::rel_to_altrep(rel62)