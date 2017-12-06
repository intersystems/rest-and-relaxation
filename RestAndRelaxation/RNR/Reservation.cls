Class RNR.Reservation Extends %Persistent
{

Index ReservationIndex On ReservationID [ Unique ];

Property ReservationID As %String [ Required ];

Property Customer As %String [ Required ];

Property StartLocation As %String [ Required ];

Property Destination As %String [ Required ];

Property StartDate As %String [ Required ];

Property EndDate As %String [ Required ];

Storage Default
{
<Data name="ReservationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReservationID</Value>
</Value>
<Value name="3">
<Value>Customer</Value>
</Value>
<Value name="4">
<Value>StartLocation</Value>
</Value>
<Value name="5">
<Value>Destination</Value>
</Value>
<Value name="6">
<Value>StartDate</Value>
</Value>
<Value name="7">
<Value>EndDate</Value>
</Value>
</Data>
<DataLocation>^RNR.ReservationD</DataLocation>
<DefaultData>ReservationDefaultData</DefaultData>
<IdLocation>^RNR.ReservationD</IdLocation>
<IndexLocation>^RNR.ReservationI</IndexLocation>
<StreamLocation>^RNR.ReservationS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}