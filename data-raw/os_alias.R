## code to prepare `os_alias` dataset goes here

# grep -F "\alias{" src/library/*/man/{unix,windows}/*.Rd
# The output is read as text into a table.
al_s <- read.table(text = "./base/man/unix/Signals.Rd:\alias{Signals}
./base/man/windows/shell.exec.Rd:\alias{shell.exec}
./base/man/windows/shell.Rd:\alias{shell}
./grDevices/man/unix/png.Rd:\alias{bmp}
./grDevices/man/unix/png.Rd:\alias{jpeg}
./grDevices/man/unix/png.Rd:\alias{png}
./grDevices/man/unix/png.Rd:\alias{tiff}
./grDevices/man/unix/savePlot.Rd:\alias{savePlot}
./grDevices/man/windows/png.Rd:\alias{bmp}
./grDevices/man/windows/png.Rd:\alias{jpeg}
./grDevices/man/windows/png.Rd:\alias{png}
./grDevices/man/windows/png.Rd:\alias{tiff}
./grDevices/man/windows/savePlot.Rd:\alias{savePlot}
./parallel/man/unix/children.Rd:\alias{children}
./parallel/man/unix/children.Rd:\alias{mckill}
./parallel/man/unix/children.Rd:\alias{readChild}
./parallel/man/unix/children.Rd:\alias{readChildren}
./parallel/man/unix/children.Rd:\alias{selectChildren}
./parallel/man/unix/children.Rd:\alias{sendChildStdin}
./parallel/man/unix/children.Rd:\alias{sendMaster}
./parallel/man/unix/mcaffinity.Rd:\alias{mcaffinity}
./parallel/man/unix/mcfork.Rd:\alias{mcexit}
./parallel/man/unix/mcfork.Rd:\alias{mcfork}
./parallel/man/unix/mclapply.Rd:\alias{mclapply}
./parallel/man/unix/mclapply.Rd:\alias{mcMap}
./parallel/man/unix/mclapply.Rd:\alias{mcmapply}
./parallel/man/unix/mcparallel.Rd:\alias{mccollect}
./parallel/man/unix/mcparallel.Rd:\alias{mcparallel}
./parallel/man/unix/pvec.Rd:\alias{pvec}
./parallel/man/windows/mcdummies.Rd:\alias{mclapply}
./parallel/man/windows/mcdummies.Rd:\alias{mcMap}
./parallel/man/windows/mcdummies.Rd:\alias{mcmapply}
./parallel/man/windows/mcdummies.Rd:\alias{pvec}
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
