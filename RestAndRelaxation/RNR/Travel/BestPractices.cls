Class RNR.Travel.BestPractices Extends %CSP.REST
{

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/reservations" Method="GET" Call="GetAllReservations" />
<Route Url="/reservations" Method="POST" Call="PostReservation" />
<Route Url="/reservation" Method="POST" Call="PostReservation" />
<Route Url="/reservation/:id" Method="GET" Call="GetReservation" />
<Route Url="/reservation/:id" Method="PUT" Call="PutReservation" />
<Route Url="/reservation/:id" Method="PATCH" Call="PatchReservation" />
<Route Url="/reservation/:id" Method="DELETE" Call="DeleteReservation" />
</Routes>
}

ClassMethod GetAllReservations() As %Status
{
	Set obj = {"reservations":[]}
	Set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT ReservationID,Customer,Destination FROM RNR.Reservation")
	While rs.%Next() {
		Do obj.reservations.%Push({
			"id": (rs.%Get("ReservationID")),
			"customer": (rs.%Get("Customer")),
			"destination": (rs.%Get("Destination"))
		})
	}
	Write obj.%ToJSON()
	Quit 1
}

ClassMethod GetReservation(id As %String)
{
	Try {
		Set reservation = ##class(RNR.Functions).OpenReservation(id)
		Set obj = {
			"id": (reservation.ReservationID),
			"customer": (reservation.Customer),
			"startLocation": (reservation.StartLocation),
			"destination": (reservation.Destination),
			"startDate": (reservation.StartDate),
			"endDate": (reservation.EndDate)
		}
		Write obj.%ToJSON()
	} Catch ex {
		Do ##class(RNR.Functions).ErrorHandling(ex)
	}
	Quit 1
}

ClassMethod PostReservation() As %Status
{
	Try {
		Set input = ##class(RNR.Functions).GetJSONData()
		Do ##class(RNR.Functions).CreateReservation(input)
	} Catch ex {
		Do ##class(RNR.Functions).ErrorHandling(ex)
	}
	Quit 1
}

ClassMethod PutReservation(id As %String) As %Status
{
	Try {
		Set input = ##class(RNR.Functions).GetJSONData()
		tstart
		Do ##class(RNR.Reservation).ReservationIndexDelete(id)
		Do ##class(RNR.Functions).CreateReservation(input,id)
		tcommit
	} Catch ex {
		trollback
		Do ##class(RNR.Functions).ErrorHandling(ex)
	}
	Quit 1
}

ClassMethod PatchReservation(id As %String) As %Status
{
	Try {
		Set input = ##class(RNR.Functions).GetJSONData()
		Do ##class(RNR.Functions).UpdateReservation(id,input)
	} Catch ex {
		Do ##class(RNR.Functions).ErrorHandling(ex)
	}
	Quit 1
}

ClassMethod DeleteReservation(id As %String) As %Status
{
	Try {
		// Try to open the reservation first to verify that it exists. If not, we throw an exception.
		Set reservation = ##class(RNR.Functions).OpenReservation(id)
		Do ##class(RNR.Reservation).ReservationIndexDelete(id)
	} Catch ex {
		Do ##class(RNR.Functions).ErrorHandling(ex)
	}
	Quit 1
}

}