import { format } from 'date-fns'
import inquirer from 'inquirer'
import { runCommand } from './utils'

const prompt = inquirer.createPromptModule({ output: process.stderr }) // To not have prompt output part of stdout that could be piped to other programs

export const getListOfMeetings = () => {
  const bulletIndicator = '3b95a551-26f9-4bc0-bfbc-33b1ecb8155f'
  const result = runCommand('icalBuddy', [
    '-b',
    bulletIndicator,
    '-ea',
    'eventsNow',
  ])
  const toObject = (meeting) =>
    meeting
      .trim()
      .split(rNewLine)
      .reduce(lineToObjectReducer, [])
      .reduce((result, obj) => ({ ...result, ...obj }), {})

  return result
    .split(bulletIndicator)
    .filter((i) => i.length)
    .map(toObject)
}

/**
 * Interactive prompts to select meeting
 * @param meetings
 */
export const selectMeeting = async (meetings) => {
  if (meetings.length > 1) {
    const { meeting } = await pickSelectedMeeting(meetings)
    return meetings.filter((m) => m.title === meeting)[0]
  } else if (meetings.length < 1) {
    const { title } = await createMeetingTitle()
    const d = new Date()
    return {
      title,
      time: format(d, 'hh:mm'),
    }
  } else {
    return meetings[0]
  }
}

export const createMeetingHeader = (meeting, content) => {
  return [
    '---',
    ...Object.keys(meeting)
      .filter((key) => key !== 'notes')
      .map((key) => `${key}: ${meeting[key]}`),
    '---',
    content,
    ...Object.keys(meeting)
      .filter((key) => key == 'notes')
      .map((key) => `\n---\n${key}: ${meeting[key]}`),
  ].join('\n')
}

export const createMeetingFilename = (meeting) =>
  `${format(new Date(), 'yyyy-MM-dd')}${
    '-' + meeting.time || ''
  }-${meeting.title
    .split(' ')
    .filter((c) => c !== '-')
    .join('-')}.md`

const pickSelectedMeeting = async (meetings) =>
  await prompt([
    {
      type: 'list',
      name: 'meeting',
      message: 'For which meeting?',
      choices: meetings.map((m) => m.title),
    },
  ]).catch(console.error)

const createMeetingTitle = async () =>
  await prompt([
    {
      type: 'input',
      name: 'title',
      message: 'Meeting title?',
      validate(value) {
        const valid = !isNaN(value.length)
        return valid || 'Please enter a meeting title'
      },
    },
  ]).catch(console.error)

const rNewLine = /\r?\n/
const indentationAmount = (str) => str.replace(/^(\s*).*$/, '$1').length

/**
 * Parse line to array of objects
 * @param acc
 * @param line
 */
const lineToObjectReducer = (acc, line) => {
  const indentation = indentationAmount(line)
  const level = indentation / 4

  if (level === 0) return [...acc, { title: line }]
  if (level === 1) return [...acc, level1Parse(line)]
  if (level > 1) return level2Parse(acc, line)

  return acc
}

/**
 * Parse key/val string to object
 * @param line
 */
const level1Parse = (line) => {
  const matchKeyVal = /^([a-zA-Z]+):(.+)/g
  const matchTime = /^([0-9]+:[0-9]+).-.([0-9]+:[0-9]+)/g

  const [, key, val] = matchKeyVal.exec(line.trim()) || []
  if (key && val) return { [key]: val }

  const [, start, end] = matchTime.exec(line.trim()) || []
  if (start && end)
    return {
      time: `${start}-${end}`,
    }

  return {}
}

/**
 * Add string to last item in the array
 * @param acc
 * @param line
 */
const level2Parse = (acc, line) => {
  let newAcc = JSON.parse(JSON.stringify(acc)) // clone array
  const i = newAcc.length - 1 // Find last index
  const key = Object.keys(newAcc[i])[0] // Find the first (and only key of the object)

  newAcc[i][key] += '\n' + line // Add new line to the string

  return newAcc
}
