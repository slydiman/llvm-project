// RUN: %clang_analyze_cc1 -analyzer-checker=core -w -DNO_CROSSCHECK -verify %s
// RUN: %clang_analyze_cc1 -analyzer-checker=core -w -analyzer-config crosscheck-with-z3=true -verify %s
// REQUIRES: z3

// XFAIL: *

typedef struct o p;
struct o {
  struct {
  } s;
};

void q(*r, p2) { r < p2; }

void k(l, node) {
  struct {
    p *node;
  } * n, *nodep, path[sizeof(void)];
  path->node = l;
  for (n = path; node != l;) {
    q(node, n->node);
    nodep = n;
  }
  if (nodep) // expected-warning {{Branch condition evaluates to a garbage value}}
    n[1].node->s;
}
