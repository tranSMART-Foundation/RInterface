# Copyright 2014, 2015 The Hyve B.V.
# Copyright 2014 Janssen Research & Development, LLC.
#
# This file is part of tranSMART R Client: R package allowing access to
# tranSMART's data via its RESTful API.
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version, along with the following terms:
#
#   1. You may convey a work based on this program in accordance with
#      section 5, provided that you retain the above notices.
#   2. You may convey verbatim copies of this program code as you receive
#      it, in any medium, provided that you retain the above notices.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

getSubjects <- function(study.name, as.data.frame = TRUE) {
    .ensureTransmartConnection()

    serverResult <- .transmartGetJSON(paste("/studies/", study.name,"/subjects", sep=""))
    listOfSubjects <- serverResult$subjects

    subjectIDs <- sapply(listOfSubjects, FUN = function(x) { x$inTrialId })
    names(listOfSubjects) <- subjectIDs

    # Don't expose id, it should not be used and will be removed from a future version of rest-api
    # COMPAT: remove this block if support for the old rest-api is dropped.
    if (length(listOfSubjects) && "id" %in% names(listOfSubjects[[1]])) {
        for (i in seq_along(patientSet$patients)) {
            listOfSubjects[[i]]$id <- NULL
        }
    }

    if (as.data.frame) return(.listToDataFrame(listOfSubjects))
    listOfSubjects
}
