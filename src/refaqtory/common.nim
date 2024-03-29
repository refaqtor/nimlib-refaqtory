#common.nim

import os, strutils, osproc

# const respath* = "../res" / hostCPU / hostOS
const configFolderName = ".refaqtory"
const workTag* = "work"

proc getPath*(rp: string) : string =
    discard rp.existsOrCreateDir
    assert existsDir rp
    return rp

proc configPath*() : string =
    return getPath(unixToNativePath getHomeDir() / configFolderName)
    
proc projectPath*(project: string) : string =
    return getPath(configPath() / project)
    
proc workPath*(project: string) : string =
    return getPath(project.projectPath() / workTag)



#--- DISPLAY LEVEL

var displayLevel: int
# error = 0, state = 1, activity = 2, debug = 3
proc setDisplay*(display = 1) =
    displayLevel=display

proc see*(level = 0, message: string) =
    if level <= displayLevel:
        echo message
    if displayLevel > 3:
        var log: File
        if log.open(configPath()/"see.log", fmAppend):
            log.writeLine(message)
        defer:
            log.close()

proc runProcess*(cmd: string; wrkdir: string = ""): TaintedString  =
    4.see "run cmd : " & cmd
    let mycurdir = getCurrentDir()
    if wrkdir != "":
        setCurrentDir wrkdir
    result = execProcess cmd
    setCurrentDir mycurdir
    return result


# Version
proc gitVer(): string=
    let logfile = "gitlog.txt"
    discard staticExec("git rev-parse HEAD > " & logfile)
    logfile.readFile().splitLines()[0][0..8]
    
const versionTag* = gitVer()

# const VcsInfo = staticExec("git rev-parse HEAD")
const VcsInfo = staticExec("fossil info").split("checkout:")[1].strip()
const thisVersion* = newConstVersion(
    name="mynimall",
    tag=versionTag,
    date=CompileDate,
    time=CompileTime,
    vcs=VcsInfo[0..7],
    extra="nim ver: " & NimVersion)

proc newVersions*(): Versions =
    result = @[newVersion(thisVersion)]

var exeVersions* = newVersions()

