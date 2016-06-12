module selector(A, B, Y);
  input [0:6] A;
  input [0:2] B;
  output Y;

  wire not_a, not_b, not_c;
  not(not_a, B[0]);
  not(not_b, B[1]);
  not(not_c, B[2]);

  wire aa, ab, ac, ad, be, bf, bg;
  and(aa, A[0], not_a);
  and(ab, A[1], not_a);
  and(ac, A[2], not_a);
  and(ad, A[3], not_a);
  and(be, A[4], B[0]);
  and(bf, A[5], B[0]);
  and(bg, A[6], B[0]);

  wire aaa, aab, abc, abd, bae, baf, bbg;
  and(aaa, aa, not_b);
  and(aab, ab, not_b);
  and(abc, ac, B[1]);
  and(abd, ad, B[1]);
  and(bae, be, not_b);
  and(baf, bf, not_b);
  and(bbg, bg, B[1]);

  wire aaaa, aabb, abac, abbd, baae, babf, bbag;
  and(aaaa, aaa, not_c);
  and(aabb, aab, B[2]);
  and(abac, abc, not_c);
  and(abbd, abd, B[2]);
  and(baae, bae, not_c);
  and(babf, baf, B[2]);
  and(bbag, bbg, not_c);

  wire orA, orB, orC, orD, orE;
  or(orA, aaaa, aabb);
  or(orB, abac, abbd);
  or(orC, baa3, babf);
  or(orD, orA, orB);
  or(orE, orC, bbag);

  or(Y, orD, orE);
endmodule
