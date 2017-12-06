Class RNR.Functions
{

ClassMethod OpenReservation(id As %String) As RNR.Reservation
{
	Set obj = ##class(RNR.Reservation).ReservationIndexOpen(id)
	If '$IsObject(obj) {
		Throw ##class(RNR.Exception.NotFound).%New("Reservation not found")
	}
	Quit obj
}


ClassMethod GetJSONData() As %DynamicObject
{
	// Throw our own exception if the request body does not contain valid JSON.
	Try {
		Set obj = ##class(%DynamicObject).%FromJSON(%request.Content)
	} Catch ex {
		Throw ##class(RNR.Exception.BadRequest).%New("Invalid JSON")
	}
	Quit obj
}

ClassMethod SetProprtiesOfReservationObject(ByRef reservation As RNR.Reservation, input as %DynamicObject) [ Private ]
{
	// Set only the properties that are defined in the dynamic object.
	// This is so we can use the same code for POST, PUT, and PATCH requests.
	// Empty properties will fail validation.
	
	If input.%IsDefined("customer") {
		Set reservation.Customer = $zstrip(input.customer,"<>W")
	}
	
	If input.%IsDefined("startLocation") {
		Set reservation.StartLocation = $zstrip(input.startLocation,"<>W")
	}
	
	If input.%IsDefined("destination") {
		Set reservation.Destination = $zstrip(input.destination,"<>W")
	}
	
	If input.%IsDefined("startDate") {
		Set reservation.StartDate = $zstrip(input.startDate,"<>W")
	}
	
	If input.%IsDefined("endDate") {
		Set reservation.EndDate = $zstrip(input.endDate,"<>W")
	}
}

ClassMethod UpdateReservation(id As %String, input As %DynamicObject)
{
	Set reservation = ..OpenReservation(id)
	Do ..SetProprtiesOfReservationObject(.reservation,input)
	Do ..ValidateReservation(reservation)
	Set status = reservation.%Save()
	If $$$ISERR(status) {
		Throw ##class(%Exception.StatusException).CreateFromStatus(status)
	}
}

ClassMethod CreateReservation(input As %DynamicObject, id As %String = {##class(%PopulateUtils).String(5)})
{
	Set reservation = ##class(RNR.Reservation).%New()
	Set reservation.ReservationID = id
	Do ..SetProprtiesOfReservationObject(.reservation,input)
	Do ..ValidateReservation(reservation)
	Set status = reservation.%Save()
	If $$$ISERR(status) {
		Throw ##class(%Exception.StatusException).CreateFromStatus(status)
	}
}

ClassMethod ValidateReservation(reservation As RNR.Reservation)
{
	If reservation.Customer = "" {
		Throw ##class(RNR.Exception.BadRequest).%New("Customer cannot be empty")
	}
	
	If reservation.StartLocation = "" {
		Throw ##class(RNR.Exception.BadRequest).%New("Start location cannot be empty")
	}
	
	If reservation.Destination = "" {
		Throw ##class(RNR.Exception.BadRequest).%New("Destination cannot be empty")
	}
	
	If reservation.StartDate = "" {
		Throw ##class(RNR.Exception.BadRequest).%New("Start date cannot be empty")
	}
	
	If reservation.EndDate = "" {
		Throw ##class(RNR.Exception.BadRequest).%New("End date cannot be empty")
	}
	
	// Catch <ILLEGAL VALUE> error returned by $zdateh and throw our own exception. 
	Try {
		Set x = $zdh(reservation.StartDate,3)
	} Catch {
		Throw ##class(RNR.Exception.BadRequest).%New("Invalid format for start date")
	}
	
	Try {
		Set x = $zdh(reservation.EndDate,3)
	} Catch {
		Throw ##class(RNR.Exception.BadRequest).%New("Invalid format for end date")
	}
	
	If reservation.StartDate > reservation.EndDate {
		Throw ##class(RNR.Exception.BadRequest).%New("Start date must be earlier than end date")
	}
}

ClassMethod ErrorHandling(ex)
{
	If ex.%IsA("RNR.Exception.Base") {
		Set %response.Status = ex.#HTTPStatus
		If ex.#LogError {
			Do ex.Log() // Write to application error log (^ERRORS)
		}
		Set obj = {"error": (ex.Name)}
		Write obj.%ToJSON()
	} Else {
		Set %response.Status = "500 Internal Server Error"
		Do ex.Log() // Write to application error log (^ERRORS)
		Set obj = {"error": ($System.Status.GetOneErrorText(ex.AsStatus()))}
		Write obj.%ToJSON()
	}
}

}