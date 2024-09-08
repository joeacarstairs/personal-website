type Digit = '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';

type Link = {
  href: string,
  title: string,
  description: string,
  isoDateAdded: `20${Digit}${Digit}-${'0'|'1'}${Digit}-${'0'|'1'|'2'|'3'}${Digit}`,
};

const LINKS: Link[] = [
  {
    href: 'https://dl.acm.org/doi/pdf/10.1145/3613904.3642596',
    title: 'Is Stack Overflow Obsolete? An Empirical Study of the Characteristics of ChatGPT Answers to Stack Overflow Questions',
    description: 'ChatGPT 3.5 gives bad answers half the time, and programmers miss the mistakes almost half the time. Be careful out there, folks.',
    isoDateAdded: '2024-06-04',
  },
  {
    href: 'https://www.colinmcginn.net/primary-and-secondary-values',
    title: 'Primary and Secondary Values',
    description: 'Colin McGinn makes the case for primary and secondary moral values, just as there are primary and secondary qualities, apparently thereby managing to assert both moral realism and anti-realism at the same time without contradiction.',
    isoDateAdded: '2024-06-05',
  },
  {
    href: 'https://pluralistic.net/2024/05/24/record-scratch/#autoenshittification',
    title: 'Pluralistic: They brick you because they can',
    description: 'Cory Doctorow writes incessantly about the harms of monopolised markets. This essay is particularly good, because he collects many of monopolists’ greatest hits from recent years. Do keep reading to the end. It just gets better.',
    isoDateAdded: '2024-06-05',
  },
  {
    href: 'https://johan.hal.se/wrote/2024/06/05/parenting',
    title: 'Parenting',
    description: '‘Once you find yourself in the position of being someone’s father you’ll quickly realize that you’re not actually raising anyone here, you just happen to be the veteran in the trenches alongside them, showing them the ropes and hoping they’ll survive and turn out okay.’',
    isoDateAdded: '2024-06-05',
  },
  {
    href: 'https://www.bbc.co.uk/programmes/m001yshl',
    title: 'Boys',
    description: 'Catherine Carr did a fantastic job of unveiling how teenage boys are experiencing masculinity in Britain today. Plenty here to surprise, shock and inspire.',
    isoDateAdded: '2024-06-05',
  },
  {
    href: 'https://www.bcs.org/articles-opinion-and-research/the-computing-revolution-how-the-next-government-can-transform-society-with-ethics-education-and-equity-in-technology',
    title: 'BCS manifesto',
    description: 'Good for what it is. Good policies. Succinct. Should be the beginning (<em>not</em> the end) of some interesting conversations.',
    isoDateAdded: '2024-06-05'
  },
  {
    href: 'https://broughtonspurtle.org.uk/news/gone-not-forgotten',
    title: '154 McDonald Road: Gone but not Forgotten',
    description: 'A superb tribute to the building and analysis of the failures of the planning system. This was published in my free local newsletter, and is worthy of any broadsheet newspaper.',
    isoDateAdded: '2024-06-07',
  },
  {
    href: 'https://thehistoryoftheweb.com/beware-the-cloud-of-hype',
    title: 'Beware the cloud of hype',
    description: 'Jay Hoffman spots some striking parallels between the current AI hype and the dot-com bubble.',
    isoDateAdded: '2024-06-07',
  },
  {
    href: 'https://eff.org/saving-the-news',
    title: 'Saving the News from Big Tech',
    description: 'Cory Doctorow, writing for the Electronic Frontier Foundation, argues that to save news media, we need to dismantle ad-tech monopolies, ban surveillance advertising, open up app stores and have an end-to-end web.',
    isoDateAdded: '2024-06-07',
  },
  {
    href: 'https://www.fastcompany.com/91132854/instagram-training-ai-on-your-data-its-nearly-impossible-to-opt-out',
    title: 'Instagram is training AI on your data. It’s nearly impossible to opt out',
    description: 'Yuck, yuck, yuck. Makes me glad I’m not on Instagram. For people already stuck there, though, this just sucks. Highly recommend either opting out of AI training or quitting Insta, if only to give the twits the middle finger they deserve.',
    isoDateAdded: '2024-06-14',
  },
  {
    href: 'https://gomakethings.com/state-based-ui-is-an-anti-pattern',
    title: 'State-based UI is an anti-pattern',
    description: 'Chris Ferdinandi has a hot take here. I would be keen to test this idea out one day: push the limits of how much complex state you can manage within the light DOM.',
    isoDateAdded: '2024-06-14',
  },
  {
    href: 'https://motherduck.com/blog/big-data-is-dead',
    title: 'Big Data is Dead',
    description: 'Did you know that most organisations store less than 100GB, and almost all analytics is run on the last 24h of data? I didn’t. Though take it all with a pinch of salt: the guy’s writing on his company blog which sells traditional data warehouses.',
    isoDateAdded: '2024-06-17',
  },
  {
    href: 'https://conduition.io/coding/ticketmaster',
    title: "Reverse Engineering TicketMaster's Rotating Barcodes (SafeTix)",
    description: 'Who doesn\'t like a classic David-and-Goliath hacker story? Also, if you\'re American, please <a href="https://www.breakupticketmaster.com">break up TicketMaster</a>. If you\'re in the UK, it\'s not quite as bad, but <a href="https://assets.publishing.service.gov.uk/media/5519473540f0b61401000087/final_report.pdf">it\'s still really bad</a>. Use alternatives where you can.',
    isoDateAdded: '2024-07-16',
  },
  {
    href: 'https://www.luu.io/posts/dont-use-booleans',
    title: 'Don’t use booleans',
    description: "A nice idea. But I think this advice only applies well when you've got many inter-dependent flags. If you have independent flags, re-writing those as enums will just end up with you re-implementing the boolean type for every parameter, and not getting much profit, I reckon.",
    isoDateAdded: '2024-07-16',
  },
  {
    href: 'https://blog.scottlogic.com/2024/07/05/story-points-are-wasting-time.html',
    title: 'Story points are wasting time',
    description: "Pretty convincing to me. The biggest potential weakness in his argument is his claim that none of the most common reasons why devs disagree on story points exposes anything which ought to be resolved in an estimation meeting. If you can provide other common reasons besides the ones Dave considered, you could rebut his argument. I don't feel experienced enough to judge this myself.",
    isoDateAdded: '2024-07-17',
  },
  {
    href: 'https://www.goldmansachs.com/intelligence/pages/gs-research/gen-ai-too-much-spend-too-little-benefit/report.pdf',
    title: 'Goldman Sachs Top of the Mind, Issue 129',
    description: 'Read the interviews. Economists give interesting, and diverse, opinions on the economic potential of LLMs.',
    isoDateAdded: '2024-07-18',
  },
];

export default LINKS;
