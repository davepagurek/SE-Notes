#!/usr/bin/env node

const fs = require('fs');
const data = "" + fs.readFileSync('index.md');

const questions = [];

const keypress = async () => {
  process.stdin.setRawMode(true);
  return new Promise(resolve => process.stdin.once('data', (buf) => {
    process.stdin.setRawMode(false);

    key = '' + buf;
    if (key.charCodeAt(0) == 3) {
      // ctrl c
      process.exit();
    }
    resolve();
  }));
};

const shuffle = (a) => {
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
};

const allMatches = (str, regexp, callback) => {
  let match = regexp.exec(str);
  while (match !== null) {
    callback(match);
    match = regexp.exec(str);
  }
};

allMatches(data, /\*\*(.+)\*\*: (.+)$/mg, (match) => questions.push({q: match[1], a: match[2]}));
allMatches(data, /(?:^|- )([^-\n]*)\*\*(.+)\*\*([^:\n]+)$/mg, (match) => questions.push({q: match[2], a: (match[1] + match[2] + match[3]).replace(/\*\*/g, '')}));
allMatches(data, /(?:^|- )([^\*\n-]+): (.+)$/mg, (match) => questions.push({q: match[1], a: match[2]}));
allMatches(data, /\n([^-\*\n:]+)\n((?:[^\n]+\n)+)/g, (match) => {
  q = match[1];

  answers = [];
  allMatches(match[2], /^- ([^:\n]+)/mg, (match) => answers.push(match[1].replace(/\*\*/g, '')));

  if (answers.length > 0) {
    questions.push({ q, a: answers.map(a => `- ${a}`).join("\n") });
  }

  allMatches(match[2], /\n- ([^\n:]+):?\n((?:  - [^\n]+\n)+)/g, (match) => {
    subq = `${q}: ${match[1]}`;

    subanswers = [];
    allMatches(match[2], /^  - ([^:\n]+)/mg, (match) => subanswers.push(match[1].replace(/\*\*/g, '')));

    if (answers.length > 0) {
      questions.push({ q: subq, a: subanswers.map(a => `- ${a}`).join("\n") });
    }
  });
});

shuffle(questions);

(async () => {
  while (questions.length > 0) {
    const {q, a} = questions.pop();

    console.log(q);
    await keypress();
    console.log(a);
    await keypress();
    console.log('');
  }
})().then(process.exit);
