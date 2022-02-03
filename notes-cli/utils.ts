import * as cp from "child_process";

/**
 * Run command in child_process and return the result synchronous
 * @param cmd
 * @param args
 * @param childProcess
 */
export const runCommand = (
    cmd: string,
    args: string[] = [],
    childProcess: typeof cp = cp
): string => {
    const process = childProcess.spawnSync(cmd, args, {stdio: 'pipe'});
    if (process.status) {
        throw new Error(process.stderr.toString());
    }
    return process.stdout?.toString() || '';
};