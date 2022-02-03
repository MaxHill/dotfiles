import {INote} from "./INote";
import * as fs from "fs";
import {baseDir} from "./config";
import {runCommand} from "./utils";

export const createNoteFromPath = (filePath, content = '') => ({content, ...splitFileAndPath(filePath)});

export const addMdToFilename = (note: INote) => ({...note, fileName: addMdExtension(note.fileName)})

export const openNote = (note: INote) => {
    const filePath = note.path + note.fileName;
    runCommand('mvim', [filePath, '--cmd',  `cd ${baseDir}`]);
    process.exit(0); // exit this nodejs process
}

const splitFileAndPath = (filePath: string): Partial<INote> => {
    const pathStrSplit = filePath.split('/');
    const fileName = pathStrSplit.pop();
    const path = pathStrSplit.join('/') + '/';
    return {fileName, path};
}

export const addTrailingSlash = (str: string) => (str.length < 1 || str.endsWith('/')) ? str : `${str}/`;

const addMdExtension = (filename: string) => {
    if (!filename.endsWith('.md')) return filename + '.md';
    return filename;
}

export const createFile = (note: INote) => {
    const filePath = note.path + note.fileName;
    if (fs.existsSync(filePath)) return note

    fs.mkdirSync(note.path, {recursive: true});
    fs.writeFileSync(filePath, note.content);
    return note;
}