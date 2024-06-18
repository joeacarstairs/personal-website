---
title: LLMs do not understand anything
description: >-
  Save this for the next time someone tells you that LLMs 'understand' things.
pubDate:
  year: 2024
  month: 06
  day: 13
---

LLMs do not understand what they are talking about. They just don't. It's not
how they're built. They have a statistical model of language, not a semantic
one. Philosophical puzzles about whether silicon can be conscious
_do not arise_, because LLMs are _not even close to the right shape_ for having
_anything like_ 'understanding'.

If you don't believe me, there are plenty of examples out there on the Internet,
but this is as good as any. It includes Chat GPT 4o explaining in detail why
\~\~A → \~A (which is a classical contradiction) is trivially true in classical
logic.

It's even better given that I had explicitly asked it to explain why that
sentence implies the trivial logic, not why it is trivially true. And even had
the explanation not been complete garbage from beginning to end, it would only
have shown that the sentence was _true_, not that it was trivial.

In other words, the output:

- Attempts to prove a contradiction (unprompted!)
- Confuses the concepts 'truth' and 'triviality'
- Is irrelevant to the prompt

In case you want it handy, I'll put the full conversation down below. The good
bit is at the end. The only edits I've made are to replace TeX syntax with
Unicode.

<dl>
<dt>
Me
</dt>
<dd>
You have the following axioms. <br>
1. |- (A -> B) -> A <br>
2. |- (~B -> ~A) -> (A -> B) <br>
3. |- (A -> (B -> C)) -> ((A -> B) -> (A -> C)) <br>
4. A -> B, A |- B <br>
Prove ~~A -> A. <br>
</dd>

<dt>
Chat GPT 4o
</dt>
<dd>
To prove \~\~ A → A, we will use the given axioms and inference rules. Let's denote the axioms as follows:

1. ⊢ (A → B) → A
2. ⊢ (\~ B → \~ A) → (A → B)
3. ⊢ (A → (B → C)) → ((A → B) → (A → C))
4. If A → B and A, then ⊢ B

Here is the proof step-by-step:

1. **Axiom (2) Instantiation:**  
   From axiom 2, we have:

   ⊢ (\~ A → \~\~ A) → (\~\~ A → A)

   Let B = A and A = \~ A.

2. **Intermediate Step:**  
   To use this axiom, we need to show \~ A → \~\~ A.

3. **Negation Introduction:**  
   By definition of negation, \~ A → \~\~ A is a tautology, because if A is false, then \~ A is true, and \~\~ A (which is A) must be false, making \~ A → \~\~ A always true.

4. **Modus Ponens Application:**  
   Since \~ A → \~\~ A is true, we apply modus ponens (axiom 4) to derive:

   ⊢ \~\~ A → A


Thus, we have proved \~\~ A → A using the given axioms and inference rules.
