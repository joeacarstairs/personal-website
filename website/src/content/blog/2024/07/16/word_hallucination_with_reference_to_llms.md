---
title: The word ‘hallucination’ with reference to LLMs
description: >-
  What does the word ‘hallucination’ actually mean in reference to LLMs? And
  where does that word come from? I’ve trawled the academic literature for
  answers.
pubDate: 2024-07-16
---

The word, ‘hallucination’ as applied to LLMs has me enthralled right now. It’s
such a **weird** word. And problematic, I think.

If you don’t know what I’m on about, have a quick look at
[IBM’s introduction to the topic](https://www.ibm.com/topics/ai-hallucinations).
It gives you a good intuition what people are talking about, and helpfully
illustrates the deep conceptual confusions which have me gripped.

But this got me asking: what do people actually mean when they say that an LLM
is ‘hallucinating’? And why that word? Where does it come from, and how did it
end up in our mouths?

As far as I could see, nobody seems to have answered this question before, except
with the odd bit of unsubstantiated guessing. I think it’s important that we
know where this word came from and what it means.

So I ended up going on a bit of a treasure hunt. I’ve skimmed well over a
hundred academic articles to trace where the word came from, how it’s been used
over time, and how it’s spread from field to field.

The result is that I have what I hope is a pretty compelling story of where this
weird old word come from and what it’s supposed to mean. I’ve also got an
excruciating amount of evidence.

What I’ll do, is first present my story, and then step through the excruciating
detail, providing you with all my sources, so you can check my working, and
perhaps see what important evidence I might have missed. If you’re just here for
the headlines, you don’t have to read the excruciating bits.

Before I proceed, two caveats.

1. I am not a subject matter expert. Judge the quality of my arguments and my
   evidence. Do not treat me as an authority.
2. For the purposes of this post, I’m just considering academic literature.
   The ways that people use the word ‘hallucination’ in popular discourse may be
   quite different. (For the record, I think they do: but that’s a story for
   another day.)

## The long and short of it

So this is my theory.

In 1999, the word ‘hallucination’ was coined accidentally and off-hand by a
couple of researchers, Baker and Kanade, in the field of computer vision (CV).

The word caught on in CV, and came to have a fairly unambiguous meaning.
Given an image with missing pixels you want to fill in, ‘hallucinating’ meant
generating those missing pixels by means of information in a deep learning
model’s training data, rather than by means of any information contained in the
input image. (This was also known as ‘example-based in-painting’). It was a term
of art, not jargon.

Then, sometime between 2017 and the end of 2018, a few different researchers in
natural language processing (NLP) adopted the term. They were probably aware of
the term's usage in CV, and transferred it to mean something similar in NLP.

When these NLP researchers used it, they used it to refer to when a model
produces content which is irrelevant to the input, or contains information not
contained in the input.

When the word ‘hallucination’ first appeared in two or three papers in NLP, the
authors used it as a technical term for their own limited purposes. However, it
was soon adopted in various contexts for similar concepts.

For example, in image captioning, ‘hallucination’ came to mean producing a
caption which mentions an object which wasn’t depicted in the input image. In
machine translation, it came to mean generating a translation which was in the
right language, but which meant something completely irrelevant to the input.
In abstractive summarisation, it came to mean producing a summary containing
details which weren’t in the text the model was supposed to summarise.

When the term entered NLP, it underwent a striking transformation. It acquired
a **valence**.

In CV, the term referred to normal behaviour, and was value-neutral. It was just
a description of what a certain machine does. ‘We need to fill in these missing
pixels. The model will do that by hallucinating them.’

In contrast, in NLP, the term ‘hallucination’ was always used to describe
**abnormal** behaviour, and almost always used with a negative valency. In other
words, while CV folk used it to describe what they expected their models to do,
NLP folk used it to describe a **bug**.

(There were odd exceptions, though. You do get the periodic paper which insists
that there are positive applications of hallucination. But the fact they have to
insist so hard rather proves that that boat has already sailed. And even they
are still buying in to the idea that hallucination is abnormal behaviour.)

Now, that brings us up to about 2020. From 2020, we get another change.

From about 2020 until the present, academics have attempted to **jargonise**
the word ‘hallucination’. Broadly, they have so far **failed**.

When I say that people have attempted to ‘jargonise’ the word, I mean that
people are using it while assuming a specific definition. They are using it with
technical qualifiers like ‘extrinsic’. They are using it without explaining the
meaning or the context, as if you should already know what the word means. And
‘hallucination’ itself is becoming an object of study.

When I say that they have ‘failed’, I mean that there is no widely agreed and
specific meaning for the word, which in my mind, is a crucial feature of jargon.
However, the intended meanings tend to coalesce around the idea of an abnormal
behaviour of LLMs whereby they produce output which is not epistemically
supported by their input.

## Excruciata

OK, that was the long and short of it. Now for the excruciating detail. To
recap, I think these six claims are enough to support my theory:

1. Since 2022, academics have treated ‘hallucination’ as jargon
2. Since 2017/18, the word ‘hallucination’ has typically been used to describe
   LLMs producing unfaithful output
3. Up to now, academics have not agreed a specific meaning for the word
   ‘hallucination’
4. The word ‘hallucination’ entered the NLP literature around 2017/2018,
   probably from CV
5. The word ‘hallucination’ was not jargon in CV, but was a term of
   art for example-based in-painting
6. The word ‘hallucination’ entered the CV literature in Baker & Kanade 1999

I’ll work through each of these in turn, showing how I got there from the
available evidence.

Feel free to use this as a cheap way to harvest citations for your own research.

### 1. Since 2022, academics have treated ‘hallucination’ as jargon

My evidence for this is twofold: surveys of ‘hallucination’ usually treat the
word as jargon, and many original research papers do, too.

First, let’s look at those surveys. These first five all belong together.

- Ji et al 2022 [^16]
- Liu et al 2023 [^30]
- Rawte et al 2023 [^42]
- Wang, Cunxiang et al 2023 [^48]
- Huang, Lei et al 2023 [^13]

All the latter four of these surveys lean heavily on Ji et al 2022 for their
definition of ‘hallucination’.  Since they all source their definition of
‘hallucination’ from Ji et al 2022, it follows that their definitions are all
extremely similar, and often verbatim. Ji et al 2022 had this to say about the
word ‘hallucination’:

> Within the context of NLP, the most inclusive and standard definition of
> hallucination is the \[sic\] generation that is nonsensical or unfaithful to
> the provided source content.

They also made a distinction between **intrinsic** hallucination, which they
regarded as ‘the generation output that contradicts the source content’, and
**extrinsic** hallucination, which they regarded as ‘the generation output that
cannot be verify \[sic\] with the source content’. Some of the other surveys
pick up on this intrinsic/extrinsic distinction. To me, extending the word with
technical epithets suggests they regard the word itself as already having an
agreed, specific meaning.

Meanwhile, Li, Wei et al 2022 [^26], another survey, offers no definition
of ‘hallucination’, but uses it freely along with the intrinsic/extrinsic
distinction. This suggests they expect their expert readers to already know
some agreed meaning of the word ‘hallucination’. This is a hallmark of jargon in
my books.

Original research also shows the word ‘hallucination’ being used as jargon. For
example, Maynez et al 2020 [^35], despite being often cited when other authors
first introduce the term ‘hallucination’, provides no definition of the term.
They do, however, use the intrinsic/extrinsic distinction (this might be the
paper which coined the distinction).

All the following papers use the word ‘hallucination’, sometimes in passing
comments, sometimes as the principal focus of the paper, without attempting to
define the word.

- Mao et al 2020 [^32]
- Wang, Alex et al 2020 [^47]
- Lin et al 2022 [^29]
- Kumar et al 2022 [^21]
- Lee, Hwanhee et al 2022 [^23]
- Li, Junyi et al 2023 [^27]
- Guerreiro et al 2023 [^12]
- Dahl et al 2024 [^6]
- Song et al 2024 [^46]

Dahl et al 2024 also use the word without defining it, even as they tack on
their own bespoke technical epithets, ‘open-domain’ and ‘closed-domain’. Plus,
in many of these examples, the context is not enough to make clear what the word
‘hallucination’ is taken to mean.

All these examples demonstrate that the authors assume that their audience,
_viz_ technical experts, will come with an agreed and specific meaning of the
word ‘hallucination’ pre-baked and ready for precise academic application.

In other words, these authors, including both surveys and primary literature,
use the word ‘hallucination’ as if it is jargon.

### 2. Since 2017/18, the word ‘hallucination’ has typically been used to describe LLMs producing unfaithful output

Recall those surveys I referred to before. They mostly depended on Ji et al
2022’s definition, which was:

> \[...\] generation that is nonsensical or unfaithful to the provided source
> content. [^16]

Whatever we might think about ‘hallucination’, the word ‘unfaithful’ really
is a jargon word in the field of natural language processing, with an agreed,
specific meaning. An LLM is ‘unfaithful’ just in case it produces output which
is not epistemically supported by the input.

This is most often used in the case of summarisers. In that case, a summariser
is unfaithful just in case it produces a summary containing information which
is not implied by any information in the document it was supposed to summarise.

(‘Nonsensical’ is not a jargon term as far as I know. I have never encountered
any attempt in the NLP literature to define ‘nonsensical’, and although this
definition is often quoted, the term ‘nonsensical’ is rarely used in practice.)

Now, I am not claiming that this is the only way or even the dominant way in
which the term ‘hallucination’ has been used. Indeed, in section 3, I’m going to
show precisely that this is **not** the case: in fact, the word ‘hallucination’
continues to be used in diverse ways in the academic literature.

All I want to claim here is that it is **typical** for academics to use the word
‘hallucination’ to mean something in the rough area of unfaithfulness.

This is an important part of the story, because this is the meaning which links
the word most closely to its etymological roots in computer vision.

All I need to do really is provide enough citations. I know I haven’t read
everything. But if what was typical in my reading is unusual in the literature
at large, I’ve been the victim of some extraordinary bad luck. Have a look at
these papers:

- Durmus et al 2020 [^7] defines ‘hallucination’ as one of two kinds of failures
  of faithfulness
- Huang, Luyang et al 2020 [^14] defines ‘hallucination’ as ‘creating content
  not present in the input’
- Maynez et al 2020 [^35] introduces ‘hallucination’ as a cause of
  unfaithfulness
- Zhao et al 2020 [^56] defines ‘hallucination’ as ‘including material that is
  not supported by the original text’
- Nan et al 2021 [^38] defines ‘hallucination’ as putting out claims not
  supported by the input
- Zhou, Chunting et al 2021 [^59] defines ‘hallucination’ as failures of
  faithfulness in machine translation
- Mao et al 2020 [^32] clearly uses ‘hallucination’ to mean unfaithfulness
- King et al 2022 [^18] is aware of usages of ‘hallucination’ to refer to
  unfactuality, but narrows in on failures of faithfulness, which they call
  ‘consistency’

So there you have it. ‘Hallucination’ has widely been taken to roughly mean
‘unfaithfulness’.

### 3. Up to now, academics have not agreed a specific meaning for the word ‘hallucination’

So we know that it was normal for academics to use ‘hallucination’ to mean
something like ‘unfaithfulness’. But was it also normal for academics to use it
for other meanings?

I think it was. There are a number of ways which authors used the word which are
not consistent with the ‘unfaithfulness’ interpretation.

The main way is that authors have assumed that in order to be a ‘hallucination’,
the output has to **contradict** something: either the input, or the training
data, or the facts, or itself. This contrasts with the ‘faithfulness’
interpretation, under which a hallucination can be perfectly consistent with
the input, the training data, the facts, and itself, as long as it isn’t
**supported** by the input.

All the following papers are clear that hallucination requires contradicting
something, usually the facts:

- Huang, Yichong et al 2021 [^15]
- Zhu et al 2021 [^60]
- Pagnoni et al 2021 [^40]
- Shuster et al 2021 [^45]
- Zhang, Yue et al 2023 [^55]
- Rawte et al 2023 [^42]
- Dahl et al 2024 [^6]
- Magesh et al 2024 [^31]

On the other end of the spectrum, a few authors seemed to believe that
hallucinated outputs **cannot** contradict the corresponding inputs. (This is
also inconsistent with the ‘unfaithfulness’ view.)

- Durmus et al 2020 [^7]
- Huang, Luyang et al 2020 [^14]
- Nan et al 2021 [^38]

There’s also disagreement on whether ‘nonsense’, or ‘incoherence’, counts as
hallucination.

On the one hand, Durmus et al 2020 [^7] argue that nonsensical outputs are not
hallucinations, since it doesn’t make sense to ask whether nonsensical outputs
are faithful. Likewise, Shuster et al 2021 [^45] contrast hallucination with
incoherence.

But on the other hand, Pagnoni et al 2021 [^40] include misleading and incorrect
grammar in their definition of ‘hallucination’, while Ji et al 2022 [^16]
explicitly include ‘nonsensical’ outputs in their widely-quoted definition of
‘hallucination’.

Some authors have managed to recognise the ambiguity of the term. Both King
et al 2022 [^18] and Farquhar et al 2024 [^9] acknowledge that the word
‘hallucination’ has been used variably to cover failures of faithfulness and
failures of factuality, and are careful to define their terms for their own
purposes to avoid being misunderstood in the context of this ambiguity.

So it seems that although many academics have treated the term ‘hallucination’
as jargon, in actual fact, there is no widely agreed specific meaning of the
word.

<hr>

I will slide in here with a quick side note. While some authors treated
‘hallucination’ as jargon for unfaithfulness or unfactuality, other authors
contemporaneously managed to talk about these topics without using the word
‘hallucination’ at all. Here are some examples:

- Cao, Ziqiang et al 2018 [^3]
- Li, Haoran et al 2018 [^25]
- Falke et al 2019 [^8]
- Goodrich et al 2019 [^11]
- Kryściński et al 2019 [^20]
- Cao, Meng et al 2020 [^4]
- Zhang, Yuhao et al 2019 [^54]
- Marcus & Davis 2020 [^33]
- Marcus 2020 [^34]
- Krishna et al 2021 [^19]
- Bai et al 2022 [^1]
- Weidinger et al 2022 [^50]
- Perez et al 2022 [^41]
- Min et al 2023 [^36]
- Muhlgay et al 2024 [^37]

Probably not a significant enough point to merit a whole section. But there you
are. I think it adds to the picture that ‘hallucination’ is failed jargon.

### 4. The word ‘hallucination’ entered the NLP literature around 2017/2018, probably from CV

So people have been using the word ‘hallucination’ in the NLP literature
recently. But where did it come from?

I think it entered the NLP literature somewhere around 2017/18, and probably
was borrowed from the field of computer vision (CV).

I can't offer a theory for a single, original usage of the word in NLP. But
there are three papers I feel are pretty close. These are the three oldest
papers I could find in the NLP literature which use the word ‘hallucination’.

- Wiseman et al 2017 [^51]
- Rohrbach et al 2018 [^44]
- Lee, Katherine et al 2018 [^22]

Both Rohrbach et al and Lee et al use a form of language which suggests they are
intentionally coining a technical term. Here’s Rohrbach et al:

> In Figure 1 we show an example where a competitive captioning model, Neural
> Baby Talk (NBT) (Lu et al., 2018), incorrectly generates the object “bench.”
> We refer to this issue as object _hallucination_.

And here’s Lee et al:

> These mistranslations are completely semantically incorrect and also
> grammatically viable. They are untethered from the input so we name them
> **‘hallucinations’**.

I have no reason to believe that these two papers are deliberately plagiarising
each other. It’s reasonable to assume that these two papers genuinely coined a
similar term for a similar phenomenon at the same time.

Wiseman et al 2017, in contrast, doesn’t look like it’s attempting to coin a
technical term. They just use the word once, presumably as a stylistic flourish
to help illustrate their point. But they do use it for a closely related
concept.

> \[…\] we see the model hallucinates factual statements, such as “in front of
> their home crowd,” which is presumably likely according to the language model,
> but ultimately incorrect (and not supported by anything in the box- or line-
> scores).

Just to add to the picture, Ehud Reiter, in his 2018 blog post [^43], gives us
an insight into the International Natural Language Generation conference of
2018. He claims that at that conference, ‘hallucination’ was a hot topic of
discussion, and cites Rohrbach 2018 to support his claim that ‘hallucination is
a well-known problem in neural approaches to image captioning’.

It might be fruitful to have a peruse of the
[INLG 2018 Proceedings](https://aclanthology.org/events/inlg-2018) to see
whether that interest in ‘hallucination’ was reflected in the written
contributions, or if it was mainly contained in verbal discussions. I haven’t
taken the liberty to do this myself: by all means, have a look yourself and let
me know what you find!

I think all this suggests that the word ‘hallucination’ entered the field
gradually, not with a bang, and perhaps spread by word of mouth at conferences
as much as it spread through published papers, at least at first.

But we still have to explain why all these different authors seem to have
independently come up with a similar meaning for the word ‘hallucination’.

I think the best explanation is that they got the word ‘hallucination’ from
computer vision (CV). If my fifth section is cogent, then ‘hallucination’ was
used in CV to refer to deep learning models generating data based on information
in their training data, not from information contained in or implied by the
input. This would explain how independent authors in NLP all independently
coined the word ‘hallucination’ in their own field to mean pretty similar
things. They were probably aware of the usage in the CV literature and adopted
it by analogy.

So, I reckon the word ‘hallucination’ probably entered the NLP literature from a
few authors independently, and they chose that word because they were borrowing
it from the CV literature, where it was already being used for a similar
concept.

But that depends on my next claim: so let’s look at that!

### 5. The word ‘hallucination’ was not jargon in CV, but was a term of art for example-based in-painting

I want to argue that ‘hallucination’, although it wasn’t jargon, was widely used
in the computer vision (CV) literature to refer to what was more technically
called ‘example-based in-painting’, that is, filling in gaps in images using
the information from training data baked into neural networks.

First look at Baker & Kanade 1999 [^2]. If my sixth section is correct, this
is where the term entered CV, but that’s not crucial to my argument here. Even
if I’ve missed some crucial evidence, it is nonetheless pretty certain that
they had a seminal effect on the use of the word in the field – they are early
in the field’s history, and widely cited by other CV papers which use the
word ‘hallucination’. They’re even cited as the origin of the term in machine
learning by the NLP paper, Farquhar et al 2024 [^9], a quarter of a century
later.

Baker & Kanade are writing about a new algorithm they’ve used in order
to increase the resolution of low-resolution images of human faces. The
intended application is for surveillance camera footage. They use the word
‘hallucination’ once in their title (‘Hallucinating faces’), once in their
abstract, and 79 times in the main body of the text.

Across those 79 occurrences, they are using it to refer to one of three things:

- Their algorithm: _eg_ their ‘face hallucination algorithm’
- The output of their algorithm: _eg_ ‘hallucinated faces’
- What their activity does: _eg_ ‘a face is hallucinated by our algorithm’

The closest they come to explaining what they **mean** by the word is in their
abstract:

> Although numerous resolution enhancement algorithms have been proposed in the
> literature, most of them are limited by the fact that they make weak, if any,
> assumptions about the scene. We propose an algorithm that can be used to learn
> a prior on the spatial distribution of the image gradient for frontal images
> of faces. We proceed to show how such a prior can be incorporated into a
> super-resolution algorithm to yield 4-8 fold improvements in resolution (16-64
> times as many pixels) using as few as 2-3 images. The additional pixels are,
> in effect, hallucinated.

(By ‘super-resolution’, they mean increasing the resolution of images. This is
typically reduced to a particular kind of ‘image in-painting’ problem, which in
general means filling in gaps in images.)

So, their idea is that, rather than limiting your algorithm to the information
contained in the input image, you can get better results by baking in
assumptions about the image to the algorithm.

Why is this supposed to work? They hope that for a clever enough algorithm,
the information that ‘this blurry splodge is a full-frontal portrait of a
human face’ will provide just enough information to accurately guess what a
higher-resolution version of the image would have been.

As for how that information, about what full-frontal portraits of human faces
look like, gets baked into the algorithm in practice: that’s done by training
a neural network on full-frontal images of faces. Hence why this field was so
close to NLP, which, in recent years at least, has leaned heavily on neural
networking or ‘deep learning’ approaches.

To recap, they don’t provide a specific meaning, but they do use it to roughly
mean the process of inventing missing pixels in images, not on the basis of
information contained in the input, but based on information contained in
training data instead.

To see how this term was picked up by later authors in the field working on
super-resolution, in-painting and other related tasks, see:

- Criminisi 2004 [^5]
- Fawzi et al 2016 [^61]
- Nazeri et al 2019 [^39]
- Xiong et al 2019 [^53]
- Xiang et al 2022 [^52]

But also notice other papers, on similar topics, which get on just fine without
using the term at all:

- Karras et al 2017 [^17]
- Zhou, Bolei et al 2017 [^58]
- Liao et al 2018 [^28]

And notice how Wang, Zhihao et al 2020 [^49] introduce the word, as an
alternative to another technical term:

> Face image super-resolution, a.k.a. face hallucination (FH), can often help
> other face-related tasks

The fact that nobody ever attempts to define the word ‘hallucination’, and it
doesn’t appear to be required lingo in any field, no matter how niche, to me
implies that it wasn’t treated as jargon in CV, at least during the period from
1999 until 2018ish. (The usage in reference to LLMs may well have gone back to
affect the usage in CV: I haven’t checked.)

So again. The word ‘hallucination’ was used in CV roughly to mean filling in
gaps in images by means of information contained in training data, baked into an
algorithm by training a neural network on many examples. It was used widely, but
not universally, and was not treated as jargon.

### 6. The word ‘hallucination’ entered the CV literature in Baker & Kanade 1999

I think that the word ‘hallucination’ entered the CV literature in Baker &
Kanade 1999. My argument for this is pretty straightforward.

I found the word ‘hallucination’ in Baker & Kanade 1999 [^2]. I couldn’t find it
in CV anywhere earlier.

To add to that, they don’t use the word ‘hallucination’ in a way which suggests
that they intentionally borrowed it from somewhere else.

My best theory is that they wanted a name for their algorithm to mark it out
from the competition, and the glove fit. I think that’s plausible enough, and
it’s consistent with the way Baker & Kanade use the word.

It’s also worth noting that according to Zhiwei et al 2009 [^57], the
foundational work in the field was published only in the same year (_viz_
Freeman & Pasztor 1999 [^10]). So there wasn’t really anywhere else for the word
to have come **from**. The only possibility is that they borrowed the word from
another field. If anybody reading this is able to suggest other fields which
used the word ‘hallucination’ before 1999, please let me know!

## Congratulations

If you’ve made it this far, you are a **hero**. Pat yourself on the back. Please
send me your corrections!

---

I have made little to no attempt to normalise these references into a standard
citation format. Please don’t tell the citation police.

[^1]: [Bai et al 2022. Training a Helpful and Harmless Assistant with Reinforcement Learning from Human Feedback. arXiv:2204.05862v1 \[cs.CL\] 12 Apr 2022](https://arxiv.org/abs/2204.05862)
[^2]: [Baker, Simon & Kanade, Takeo 1999. Hallucinating Faces. Tech. Report, CMU-RI-TR-99-32, Robotics Institute, Carnegie Mellon University, September, 1999](https://www.ri.cmu.edu/publications/hallucinating-faces-2)
[^3]: [Cao, Ziqiang et al 2018. Faithful to the Original: Fact Aware Neural Abstractive Summarization. The Thirty-Second AAAI Conference on Artificial Intelligence (AAAI-18)](https://cdn.aaai.org/ojs/11912/11912-13-15440-1-2-20201228.pdf)
[^4]: [Cao, Meng et al 2020. Factual Error Correction for Abstractive Summarization Models. Proceedings of the 2020 Conference on Empirical Methods in Natural Language Processing, pp 6251–6258, November 16–20, 2020](https://aclanthology.org/2020.emnlp-main.506.pdf)
[^5]: [Criminisi, Perez & Toyama, "Region filling and object removal by exemplar-based image inpainting," in IEEE Transactions on Image Processing, vol. 13, no. 9, pp 1200-1212, Sept 2004, doi: 10.1109/TIP.2004.833105](https://doi.org/10.1109/TIP.2004.833105)
[^6]: [Dahl et al 2024. Large Legal Fictions: Profiling Legal Hallucinations in Large Language Models. arXiv:2401.01301v1 \[cs.CL\] 2 Jan 2024](https://arxiv.org/abs/2401.01301v1)
[^7]: [Durmus et al 2020. FEQA: A Question Answering Evaluation Framework for Faithfulness Assessment in Abstractive Summarization. Proceedings of the 58th Annual Meeting of the Association for Computational Linguistics, pp 5055–5070, July 5 - 10, 2020](https://aclanthology.org/2020.acl-main.454.pdf)
[^8]: [Falke et al 2019. Ranking Generated Summaries by Correctness: An Interesting but Challenging Application for Natural Language Inference. Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics, pp 2214–2220, Florence, Italy, July 28 - August 2, 2019](https://aclanthology.org/P19-1213.pdf)
[^9]: [Farquhar, S., Kossen, J., Kuhn, L. et al 2024. Detecting hallucinations in large language models using semantic entropy. Nature 630, 625–630 (2024). 19 June 2024. https://doi.org/10.1038/s41586-024-07421-0](https://doi.org/10.1038/s41586-024-07421-0)
[^10]: [Freeman, W. T., & Pasztor, E. C. (1999). Learning low-level vision. Proceedings of the Seventh IEEE International Conference on Computer Vision. doi:10.1109/iccv.1999.790414](https://doi.org/10.1109/iccv.1999.790414)
[^11]: [Goodrich et al 2019. Assessing The Factual Accuracy of Generated Text. arXiv:1905.13322v1 \[cs.CL\] 30 May 2019](https://arxiv.org/abs/1905.13322v1)
[^12]: [Guerreiro et al 2023. Hallucinations in Large Multilingual Translation Models. arXiv:2303.16104v1 \[cs.CL\] 28 Mar 2023](https://arxiv.org/abs/2303.16104v1)
[^13]: [Huang, Lei et al 2023. A Survey on Hallucination in Large Language Models: Principles, Taxonomy, Challenges, and Open Questions. arXiv:2311.05232v1 \[cs.CL\] 9 Nov 2023](https://arxiv.org/abs/2311.05232v1)
[^14]: [Huang, Luyang et al 2020. Knowledge Graph-Augmented Abstractive Summarization with Semantic-Driven Cloze Reward. Proceedings of the 58th Annual Meeting of the Association for Computational Linguistics, pp 5094–5107, July 5-10, 2020](https://aclanthology.org/2020.acl-main.457.pdf)
[^15]: [Huang, Yichong et al 2021. The Factual Inconsistency Problem in Abstractive Text Summarization: A Survey. arXiv:2104.14839v1 \[cs.CL\] 30 Apr 2021](https://arxiv.org/abs/2104.14839v1)
[^16]: [Ji et al 2022. Survey of Hallucination in Natural Language Generation. arXiv:2202.03629v1 \[cs.CL\] 8 Feb 2022](https://arxiv.org/abs/2202.03629v1)
[^17]: [Karras et al 2017. PROGRESSIVE GROWING OF GANS FOR IMPROVED QUALITY, STABILITY, AND VARIATION. arXiv:1710.10196v3 \[cs.NE\] 26 Feb 2018](https://arxiv.org/abs/1710.10196v3)
[^18]: [King et al 2022. Don’t Say What You Don’t Know: Improving the Consistency of Abstractive Summarization by Constraining Beam Search. arXiv:2203.08436v1 \[cs.CL\] 16 Mar 2022](https://arxiv.org/abs/2203.08436v1)
[^19]: [Krishna, Roy & Iyyer 2021. Hurdles to Progress in Long-form Question Answering. Proceedings of the 2021 Conference of the North American Chapter of the Association for Computational Linguistics: Human Language Technologies, pp 4940–4957, June 6–11, 2021](https://aclanthology.org/2021.naacl-main.393.pdf)
[^20]: [Kryściński et al 2019. Evaluating the Factual Consistency of Abstractive Text Summarization. arXiv:1910.12840v1 \[cs.CL\] 28 Oct 2019](https://arxiv.org/abs/1910.12840v1)
[^21]: [Kumar et al 2022. Language Generation Models Can Cause Harm: So What Can We Do About It? An Actionable Survey. arXiv:2210.07700v1 \[cs.CL\] 14 Oct 2022](https://arxiv.org/abs/2210.07700v1)
[^22]: [Lee, Katherine et al 2018. Hallucinations in Neural Machine Translation. Conference on Neural Information Processing Systems (NeurIPS 2018), Montréal, Canada](https://openreview.net/pdf?id=SJxTk3vB3m)
[^23]: [Lee, Hwanhee et al 2022. Factual Error Correction for Abstractive Summaries Using Entity Retrieval. Proceedings of the 2nd Workshop on Natural Language Generation, Evaluation, and Metrics (GEM), pp 439-444, December 7, 2022](https://aclanthology.org/2022.gem-1.41.pdf)
[^24]: [Lewis et al 2020. Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks. 34th Conference on Neural Information Processing Systems (NeurIPS 2020)](https://proceedings.neurips.cc/paper/2020/file/6b493230205f780e1bc26945df7481e5-Paper.pdf)
[^25]: [Li, Haoran et al 2018. Ensure the Correctness of the Summary: Incorporate Entailment Knowledge into Abstractive Sentence Summarization. Proceedings of the 27th International Conference on Computational Linguistics, pp 1430–1441, August 20-26, 2018](https://aclanthology.org/C18-1121.pdf)
[^26]: [Li, Wei et al 2022. Faithfulness in Natural Language Generation: A Systematic Survey of Analysis, Evaluation and Optimization Methods. arXiv:2203.05227v1 \[cs.CL\] 10 Mar 2022](https://arxiv.org/abs/2203.05227v1)
[^27]: [Li, Junyi et al 2023. HaluEval: A Large-Scale Hallucination Evaluation Benchmark for Large Language Models. arXiv:2305.11747v3 \[cs.CL\] 23 Oct 2023](https://arxiv.org/abs/2305.11747v3)
[^28]: [Liao, L., Hu, R., Xiao, J., & Wang, Z. (2018). Edge-Aware Context Encoder for Image Inpainting. 2018 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP). doi:10.1109/icassp.2018.8462549](https://doi.org/10.1109/ICASSP.2018.8462549)
[^29]: [Lin, Hilton & Evans 2022. TruthfulQA: Measuring How Models Mimic Human Falsehoods. Proceedings of the 60th Annual Meeting of the Association for Computational Linguistics Volume 1: Long Papers, pp 3214-3252, May 22-27, 2022](https://aclanthology.org/2022.acl-long.229.pdf)
[^30]: [Liu et al 2023. TRUSTWORTHY LLMS: A SURVEY AND GUIDELINE FOR EVALUATING LARGE LANGUAGE MODELS’ ALIGNMENT. arXiv:2308.05374v1 \[cs.AI\] 21 Mar 2024](https://arxiv.org/abs/2308.05374v1)
[^31]: [Magesh et al 2024. Hallucination-Free? Assessing the Reliability of Leading AI Legal Research Tools. arXiv:2405.20362v1 \[cs.CL\] 30 May 2024](https://arxiv.org/abs/2405.20362v1)
[^32]: [Mao et al 2020. Constrained Abstractive Summarization: Preserving Factual Consistency with Constrained Generation. arXiv:2010.12723v1 \[cs.CL\] 24 Oct 2020](https://arxiv.org/abs/2010.12723v2)
[^33]: [Marcus & Davis 2020. GPT-3, Bloviator: OpenAI’s language generator has no idea what it’s talking about. Technology Review, August 22, 2020](https://www.technologyreview.com/2020/08/22/1007539/gpt3-openai-language-generator-artificial-intelligence-ai-opinion/)
[^34]: [Marcus 2020. The Next Decade in AI: Four Steps Towards Robust Artificial Intelligence. Robust AI. 14 Feb 2020](https://arxiv.org/abs/2002.06177v1)
[^35]: [Maynez et al 2020. On Faithfulness and Factuality in Abstractive Summarization. Proceedings of the 58th Annual Meeting of the Association for Computational Linguistics, pp 1906–1919, July 5 - 10, 2020](https://aclanthology.org/2020.acl-main.173.pdf)
[^36]: [Min et al 2023. FACTSCORE: Fine-grained Atomic Evaluation of Factual Precision in Long Form Text Generation. arXiv:2305.14251v1 \[cs.CL\] 23 May 2023](https://arxiv.org/abs/2305.14251v1)
[^37]: [Muhlgay et al 2024. Generating Benchmarks for Factuality Evaluation of Language Models. arXiv:2307.06908v2 \[cs.CL\] 4 Feb 2024](https://arxiv.org/abs/2307.06908v2)
[^38]: [Nan et al 2021. Improving Factual Consistency of Abstractive Summarization via Question Answering. Proceedings of the 59th Annual Meeting of the Association for Computational Linguistics and the 11th International Joint Conference on Natural Language Processing, pp 6881–6894, August 1–6, 2021](https://aclanthology.org/2021.acl-long.536.pdf)
[^39]: [Nazeri et al 2019. EdgeConnect: Structure Guided Image Inpainting using Edge Prediction. 2019 IEEE/CVF International Conference on Computer Vision Workshop (ICCVW)](https://doi.org/10.1109/ICCVW.2019.00408)
[^40]: [Pagnoni et al 2021. Understanding Factuality in Abstractive Summarization with FRANK: A Benchmark for Factuality Metrics. Proceedings of the 2021 Conference of the North American Chapter of the Association for Computational Linguistics: Human Language Technologies, pp 4812–4829, June 6–11, 2021](https://aclanthology.org/2021.naacl-main.383.pdf)
[^41]: [Perez et al 2022. Red Teaming Language Models with Language Models. arXiv:2202.03286v1 \[cs.CL\] 7 Feb 2022](https://arxiv.org/abs/2202.03286)
[^42]: [Rawte et al 2023. A Survey of Hallucination in “Large” Foundation Models. arXiv:2309.05922v1 \[cs.AI\] 12 Sep 2023](https://arxiv.org/abs/2309.05922v1)
[^43]: [Reiter 2018. Hallucination in Neural NLG, blog post, Nov 12, 2018](https://ehudreiter.com/2018/11/12/hallucination-in-neural-nlg)
[^44]: [Rohrbach et al 2018. Object Hallucination in Image Captioning. arXiv:1809.02156v1 \[cs.CL\] 6 Sep 2018](https://arxiv.org/abs/1809.02156v1)
[^45]: [Shuster et al 2021. Retrieval Augmentation Reduces Hallucination in Conversation. arXiv:2104.07567v1 \[cs.CL\] 15 Apr 2021](https://arxiv.org/abs/2104.07567v1)
[^46]: [Song et al 2024. FineSurE: Fine-grained Summarization Evaluation using LLMs. arXiv:2407.00908v1 \[cs.CL\] 1 Jul 2024](https://arxiv.org/abs/2407.00908v1)
[^47]: [Wang, Alex et al 2020. Asking and Answering Questions to Evaluate the Factual Consistency of Summaries. Proceedings of the 58th Annual Meeting of the Association for Computational Linguistics, pp 5008–5020, July 5-10, 2020](https://aclanthology.org/2020.acl-main.450.pdf)
[^48]: [Wang, Cunxiang et al 2023. Survey on Factuality in Large Language Models: Knowledge, Retrieval and Domain-Specificity. arXiv:2310.07521v1 \[cs.CL\] 11 Oct 2023](https://arxiv.org/abs/2310.07521v1)
[^49]: [Wang, Zhihao et al 2020. Deep Learning for Image Super-resolution: A Survey. arXiv:1902.06068v2 \[cs.CV\] 8 Feb 2020](https://arxiv.org/abs/1902.06068v2)
[^50]: [Weidinger et al 2022. Taxonomy of Risks posed by Language Models. FAccT ’22, June 21–24, 2022, Seoul, Republic of Korea. doi: 10.1145/3531146.3533088](https://dl.acm.org/doi/pdf/10.1145/3531146.3533088)
[^51]: [Wiseman, Hieber & Rush 2017. Challenges in Data-to-Document Generation. arXiv:1707.08052v1 \[cs.CL\] 25 Jul 2017](https://arxiv.org/abs/arXiv:1707.08052v1)
[^52]: [Xiang et al 2022. Deep learning for image inpainting: A survey. doi: 10.1016/j.patcog.2022.109046](https://doi.org/10.1016/j.patcog.2022.109046)
[^53]: [Xiong et al 2019. Foreground-aware Image Inpainting. 2019 IEEE/CVF Conference on Computer Vision and Pattern Recognition (CVPR)](https://doi.org/10.1109/CVPR.2019.00599)
[^54]: [Zhang, Yuhao et al 2019. Optimizing the Factual Correctness of a Summary: A Study of Summarizing Radiology Reports. arXiv:1911.02541v1 \[cs.CL\] 6 Nov 2019](https://arxiv.org/abs/1911.02541v1)
[^55]: [Zhang, Yue et al 2023. Siren’s Song in the AI Ocean: A Survey on Hallucination in Large Language Models. arXiv:2309.01219v1 \[cs.CL\] 3 Sep 2023](https://arxiv.org/abs/2309.01219v1)
[^56]: [Zhao et al 2020. Reducing Quantity Hallucinations in Abstractive Summarization. Findings of the Association for Computational Linguistics: EMNLP 2020, pp 2237–2249, November 16 - 20, 2020](https://aclanthology.org/2020.findings-emnlp.203.pdf)
[^57]: [Zhiwei Xiong, Xiaoyan Sun, & Wu, F. (2009). Image hallucination with feature enhancement. 2009 IEEE Conference on Computer Vision and Pattern Recognition. doi:10.1109/cvpr.2009.5206630](https://doi.org/10.1109/cvpr.2009.5206630)
[^58]: [Zhou, Bolei et al 2017. Places: An Image Database for Deep Scene Understanding. arXiv:1610.02055v1 \[cs.CV\] 6 Oct 2016](https://arxiv.org/abs/1610.02055v1)
[^59]: [Zhou, Chunting et al 2021. Detecting Hallucinated Content in Conditional Neural Sequence Generation. Findings of the Association for Computational Linguistics: ACL-IJCNLP 2021, pp 1393–1404, August 1–6, 2021](https://aclanthology.org/2021.findings-acl.120.pdf)
[^60]: [Zhu et al 2021. Enhancing Factual Consistency of Abstractive Summarization. Proceedings of the 2021 Conference of the North American Chapter of the Association for Computational Linguistics: Human Language Technologies, pp 718–733, June 6–11, 2021](https://aclanthology.org/2021.naacl-main.58.pdf)
[^61]: [Fawzi et al 2016. Image inpainting through neural networks hallucinations. EPFL, Switzerland & IBM Research Watson, USA](https://www.cs.toronto.edu/~horst/cogrobo/papers/ivmsp2016.pdf)
