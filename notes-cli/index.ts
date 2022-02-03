#! /usr/bin/env node
import {pipe} from 'Rambda';
import {createMeetingFilename, createMeetingHeader, getListOfMeetings, selectMeeting} from "./meetings";
import {addMdToFilename, addTrailingSlash, createFile, createNoteFromPath, openNote} from "./note";
import {baseDir} from "./config";

const fs = require('fs');
const cp = require("child_process");
const {program} = require('commander');


const createMeetingNote = async ({folder, content = ""}: { folder: string, content: string }) => {
    const meetings = getListOfMeetings(); // Meeting[]
    const meeting = await selectMeeting(meetings); // Meeting

    newNote(
        baseDir + addTrailingSlash(folder) + createMeetingFilename(meeting),
        createMeetingHeader(meeting, content)
    )
}

const createNote = (filename, {folder, content}: { folder: string, content: string }) => {
    if (!filename) {
        console.error('Specify a filename');
        return;
    }

    newNote(baseDir + addTrailingSlash(folder) + filename, content);
}

const openNotes = (filename = '') => {
    openNote({fileName: filename, path: baseDir, content: ''});
}

const newNote = pipe(
    createNoteFromPath,
    addMdToFilename,
    createFile,
    openNote
)


program
    .command('new [filename]')
    .description('Create a new note')
    .option('-f, --folder <folder>', `Sub folder of basedir (${baseDir})`, '')
    .option('-c, --content <content>', `Text to be added to file`, '')
    .action(createNote)

program
    .command('meeting-note')
    .description('Create a new meeting note')
    .option('-f, --folder <folder>', `Sub folder of basedir (${baseDir})`, '')
    .option('-c, --content <content>', `Text to be added to file`, '')
    .action(createMeetingNote)

program
    .command('open [filename]')
    .description('Open notes in editor')
    .action(openNotes)

program.parse();
