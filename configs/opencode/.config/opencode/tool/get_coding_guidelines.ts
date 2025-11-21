import { tool } from "@opencode-ai/plugin"
import { readFile, readdir } from "fs/promises"
import { join, extname, basename } from "path"

export const get = tool({
  description: "Get coding guidelines for a specific programming language",
  args: {
    language: tool.schema
      .string()
      .describe("Programming language (e.g., typescript, python, javascript, java)"),
  },
  async execute(args, context) {
    try {
      // Construct the path to the guidelines file in Dropbox
      const homeDir = process.env.HOME || process.env.USERPROFILE
      const guidelinesPath = join(
        homeDir,
        "Dropbox",
        "Notes",
        "coding-guidelines",
        `${args.language.toLowerCase()}.md`
      )

      // Read the markdown file
      const content = await readFile(guidelinesPath, "utf-8")

      return `# Coding Guidelines for ${args.language}\n\n${content}`
    } catch (error) {
      // Handle file not found or other errors
      if (error.code === "ENOENT") {
        return `No coding guidelines found for ${args.language}. Available guidelines should be placed at ~/Dropbox/Notes/coding-guidelines/${args.language.toLowerCase()}.md\n\nUse 'coding_guidelines_list' to see available guidelines.`
      }
      
      return `Error reading guidelines: ${error.message}`
    }
  },
})

export const list = tool({
  description: "List all available coding guidelines",
  args: {},
  async execute(args, context) {
    try {
      const homeDir = process.env.HOME || process.env.USERPROFILE
      const guidelinesDir = join(homeDir, "Dropbox", "Notes", "coding-guidelines")
      
      // Read all files in the guidelines directory
      const files = await readdir(guidelinesDir)
      
      // Filter for markdown files and extract language names
      const languages = files
        .filter(file => extname(file) === ".md")
        .map(file => basename(file, ".md"))
        .sort()

      if (languages.length === 0) {
        return "No coding guidelines found in ~/Dropbox/Notes/coding-guidelines/"
      }

      return `Available coding guidelines:\n${languages.map(lang => `- ${lang}`).join("\n")}\n\nUse 'coding_guidelines_get' with the language parameter to retrieve specific guidelines.`
    } catch (error) {
      if (error.code === "ENOENT") {
        return "Guidelines directory not found at ~/Dropbox/Notes/coding-guidelines/. Please create this directory and add your guideline markdown files."
      }
      
      return `Error listing guidelines: ${error.message}`
    }
  },
})
