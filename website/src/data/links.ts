type Digit = '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9';

type Link = {
  href: string,
  title: string,
  description: string,
  isoDateAdded: `20${Digit}${Digit}-${'0'|'1'}${Digit}-${'0'|'1'|'2'|'3'}${Digit}`,
};

const links: Link[] = [
  {
    href: 'https://dl.acm.org/doi/pdf/10.1145/3613904.3642596',
    title: 'Is Stack Overflow Obsolete? An Empirical Study of the Characteristics of ChatGPT Answers to Stack Overflow Questions',
    description: 'ChatGPT 3.5 gives bad answers half the time, and programmers miss the mistakes almost half the time. Be careful out there, folks.',
    isoDateAdded: '2024-06-04',
  },
];

export default links;
