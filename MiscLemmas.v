(** Various lemmas that seem to be missing from the standard library. *)

Require Import QArith Qminmax.

Local Open Scope Q_scope.

Definition Qpositive := {q : Q & q > 0}.

Definition Q_of_Qpositive (q : Qpositive) := projT1 q.

Coercion Q_of_Qpositive : Qpositive >-> Q.

Definition Qnonnegative := {q : Q & q >= 0}.

Definition Q_of_Qnonnegative (q : Qnonnegative) := projT1 q.

Coercion Q_of_Qnonnegative : Qnonnegative >-> Q.

Definition Qinterval (q r : Q) := { s : Q | q <= s /\ s <= r }.

Definition Q_of_Qinterval a b (s : Qinterval a b) := projT1 s.

Coercion Q_of_Qinterval : Qinterval >-> Q.

Lemma Qopp_lt_compat : forall (p q : Q), p < q <-> -q < -p.
Proof.
  intros (a,b) (c,d).
  unfold Qlt. simpl.
  rewrite !Z.mul_opp_l. omega.
Defined.

Lemma Qplus_lt_lt_compat : forall (p q r s : Q), p < q -> r < s -> p + r < q + s.
Proof.
  auto using Qlt_le_weak, Qplus_lt_le_compat.
Qed.

Lemma Qmult_lt_positive : forall (p q : Q), 0 < p -> 0 < q -> 0 < p * q.
Proof.
  intros p q pPos qPos.
  rewrite <- (Qmult_0_l q) at 1.
  apply Qmult_lt_compat_r; assumption.
Qed.

Lemma Qopp_lt_shift_l : forall (p q : Q), -p < q <-> -q < p.
Proof.
  intros p q; split; intro H.
  - rewrite <- (Qopp_involutive p).
    apply Qopp_lt_compat.
    rewrite 2 Qopp_involutive.
    assumption.
  - rewrite <- (Qopp_involutive q).
    apply Qopp_lt_compat.
    rewrite 2 Qopp_involutive.
    assumption.
Qed.

Lemma Qopp_lt_shift_r : forall (p q : Q), p < -q <-> q < -p.
Proof.
  intros p q; split; intro H.
  - rewrite <- (Qopp_involutive p).
    apply Qopp_lt_compat.
    rewrite 2 Qopp_involutive.
    assumption.
  - rewrite <- (Qopp_involutive q).
    apply Qopp_lt_compat.
    rewrite 2 Qopp_involutive.
    assumption.
Qed.

Lemma Qlt_minus_1 : forall q : Q, q + (-1#1) < q.
Proof.
  intro q.
  rewrite <- (Qplus_0_r q) at 2.
  apply Qplus_lt_r.
  compute; reflexivity.
Qed.

Lemma Qlt_plus_1 : forall q : Q, q < q + (1#1).
Proof.
  intro q.
  rewrite <- (Qplus_0_r q) at 1.
  apply Qplus_lt_r.
  compute; reflexivity.
Qed.

Lemma Qplus_nonneg_cone : forall q r, 0 <= q -> 0 <= r -> 0 <= q + r.
Proof.
  intros q r G H.
  setoid_replace 0 with (0 + 0) ; [idtac | (compute; reflexivity)].
  apply Qplus_le_compat; assumption.
Qed.

Lemma Qplus_zero_nonneg : forall q r, 0 <= q -> 0 <= r -> q + r == 0 -> q == 0 /\ r == 0.
Proof.
  intros q r Pq Pr H.
  split.
  - apply Qle_antisym ; auto.
    setoid_rewrite <- H.
    setoid_replace q with (q + 0) at 1 ; [idtac | ring].
    apply Qplus_le_r; assumption.
  - apply Qle_antisym ; auto.
    setoid_rewrite <- H.
    setoid_replace r with (0 + r) at 1 ; [idtac | ring].
    apply Qplus_le_l; assumption.
Qed.

Require Import Qpower.

Lemma Qpower_zero0: forall p, ~p==0 -> p^0 == 1.
Proof.
intros p H.
compute ; auto.
Qed.

Lemma Qpower_nonzero0 : forall p n, ~ p==0 -> ~ p^n==0.
Proof.
intros p n G.
induction n.
- rewrite (Qpower_zero0 p).
apply Q_apart_0_1.
assumption.
-simpl.
apply (Qpower_not_0_positive p p0 G).
-simpl.
Admitted.

Lemma Qpower_strictly_pos : forall p n, 0 < p -> 0 < p^n.
Proof.
intros p n G.
rewrite (Qlt_not_eq 0 p G).
Admitted.