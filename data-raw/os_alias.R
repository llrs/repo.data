## code to prepare `os_alias` dataset goes here

# grep -F "\alias{" src/library/*/man/{unix,windows}/*.Rd
# The output is read as text into a table.
al_s <- read.table(text = "src/library/base/man/unix/Signals.Rd:\alias{Signals}
src/library/grDevices/man/unix/png.Rd:\alias{png}
src/library/grDevices/man/unix/png.Rd:\alias{jpeg}
src/library/grDevices/man/unix/png.Rd:\alias{tiff}
src/library/grDevices/man/unix/png.Rd:\alias{bmp}
src/library/grDevices/man/unix/savePlot.Rd:\alias{savePlot}
src/library/parallel/man/unix/children.Rd:\alias{children}
src/library/parallel/man/unix/children.Rd:\alias{readChild}
src/library/parallel/man/unix/children.Rd:\alias{readChildren}
src/library/parallel/man/unix/children.Rd:\alias{selectChildren}
src/library/parallel/man/unix/children.Rd:\alias{sendChildStdin}
src/library/parallel/man/unix/children.Rd:\alias{sendMaster}
src/library/parallel/man/unix/children.Rd:\alias{mckill}
src/library/parallel/man/unix/mcaffinity.Rd:\alias{mcaffinity}
src/library/parallel/man/unix/mcfork.Rd:\alias{mcfork}
src/library/parallel/man/unix/mcfork.Rd:\alias{mcexit}
src/library/parallel/man/unix/mclapply.Rd:\alias{mclapply}
src/library/parallel/man/unix/mclapply.Rd:\alias{mcmapply}
src/library/parallel/man/unix/mclapply.Rd:\alias{mcMap}
src/library/parallel/man/unix/mcparallel.Rd:\alias{mccollect}
src/library/parallel/man/unix/mcparallel.Rd:\alias{mcparallel}
src/library/parallel/man/unix/pvec.Rd:\alias{pvec}
src/library/base/man/windows/shell.exec.Rd:\alias{shell.exec}
src/library/base/man/windows/shell.Rd:\alias{shell}
src/library/grDevices/man/windows/png.Rd:\alias{png}
src/library/grDevices/man/windows/png.Rd:\alias{jpeg}
src/library/grDevices/man/windows/png.Rd:\alias{tiff}
src/library/grDevices/man/windows/png.Rd:\alias{bmp}
src/library/grDevices/man/windows/savePlot.Rd:\alias{savePlot}
src/library/parallel/man/windows/mcdummies.Rd:\alias{mclapply}
src/library/parallel/man/windows/mcdummies.Rd:\alias{pvec}
src/library/parallel/man/windows/mcdummies.Rd:\alias{mcmapply}
src/library/parallel/man/windows/mcdummies.Rd:\alias{mcMap}
", sep = ":")

os_alias <- cbind(
    Package = basename(dirname(dirname(dirname(al_s$V1)))),
    os = basename(dirname(al_s$V1)),
    file  = basename(al_s$V1),
    Source = file.path(basename(dirname(al_s$V1)), basename(al_s$V1)),
    Target = gsub("\\\alias\\{(.+)\\}", "\\1", al_s$V2)
)

usethis::use_data(os_alias, overwrite = TRUE)
# usethis::use_data(os_alias, internal = TRUE, overwrite = TRUE)
