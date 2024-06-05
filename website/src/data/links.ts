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
];

export default LINKS;
