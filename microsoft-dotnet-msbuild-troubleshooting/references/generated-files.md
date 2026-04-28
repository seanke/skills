# Generated Files

Use this when a build generates files but later targets cannot see them.

## Core Rule

If a file is created during execution, it will not be visible to evaluation-time globs. Add it to the build explicitly.

## Generated Source Files

For generated `.cs` files:

- Use `BeforeTargets="CoreCompile;BeforeCompile"`
- Add the file to `Compile`
- Add the file to `FileWrites`
- Place the file under `$(IntermediateOutputPath)`

## Non-Code Generated Files

For generated content that should copy to output:

- Use `BeforeTargets="BeforeBuild"` or `BeforeTargets="AssignTargetPaths"`
- Add the file to `None` or `Content`
- Add the file to `FileWrites`

## Why This Works

The target runs late enough that the file exists, but early enough that downstream targets can still use it.

If the file should be compiled but still is not showing up, the build ordering is wrong or the item is being added too early.
