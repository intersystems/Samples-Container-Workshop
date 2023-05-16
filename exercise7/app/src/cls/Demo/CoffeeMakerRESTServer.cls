/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// 
Class Demo.CoffeeMakerRESTServer Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
<Route Url="/test" Method="GET" Call="test"/>
<Route Url="/coffeemakers" Method="GET" Call="GetAll" />
<Route Url="/coffeemaker/:id" Method="GET" Call="GetCoffeeMakerInfo" />
<Route Url="/newcoffeemaker" Method="POST" Call="NewMaker" />
<Route Url="/coffeemaker/:id" Method="PUT" Call="EditMaker" />
<Route Url="/coffeemaker/:id" Method="DELETE" Call="RemoveCoffeemaker"/>
</Routes>
}

/// Tester method
ClassMethod test() As %Status
{
	Set cm = {
		"coffeemakerID": "20",
		"name": "My Coffee Maker",
		"brand": "Coffee Inc",
		"price": "23.45",
		"numcups": "1",
		"color": "green",
		"img": "img/coffee1.png"
	}
	Write cm.%ToJSON()
	quit $$$OK
}

// DATABASE METHODS

ClassMethod GetAll() As %Status
{
	Set tArr = []
	Set rs = ##class(%SQL.Statement).%ExecDirect(,"SELECT * FROM Demo.coffeemaker")
	While rs.%Next() {
		Do tArr.%Push({
			"img":    			(rs.%Get("Img")),
			"coffeemakerID":    (rs.%Get("CoffeemakerID")),
			"name": 			(rs.%Get("Name")),
			"brand":        	(rs.%Get("Brand")),
			"color":   			(rs.%Get("Color")),
			"numcups":          (rs.%Get("NumCups")),
			"price":        	(rs.%Get("Price"))
		})
	}
	
	Write tArr.%ToJSON()
	Quit $$$OK
}

ClassMethod NewMaker() As %Status
{
	If '..GetJSONFromRequest(.obj) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Set error = {"errormessage": "JSON not found"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	If '..ValidateJSON(obj,.error) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	Set cm = ##class(Demo.coffeemaker).%New()
	Do ..CopyToCoffeemakerFromJSON(.cm,obj)
	
	Set sc = cm.%Save()
	
	Set result={}
	do result.%Set("Status",$s($$$ISERR(sc):$system.Status.GetOneErrorText(sc),1:"OK"))
	write result.%ToJSON()
	Quit sc
}

ClassMethod EditMaker(id As %String = "") As %Status
{
	If '..GetJSONFromRequest(.obj) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Set error = {"errormessage": "JSON not found"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	If '..ValidateJSON(obj,.error) {
		Set %response.Status = ..#HTTP400BADREQUEST
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	Set cm = ##class(Demo.coffeemaker).%OpenId(id)
	If '$IsObject(cm) {
		Set %response.Status = ..#HTTP404NOTFOUND
		Set error = {"errormessage": "Coffee maker does not exist"}
		Write error.%ToJSON()
		Quit $$$OK
	}
	
	Do ..CopyToCoffeemakerFromJSON(.cm,obj)
	
	Set sc = cm.%Save()
	
	Set result={}
	do result.%Set("Status",$s($$$ISERR(sc):$system.Status.GetOneErrorText(sc),1:"OK"))
	write result.%ToJSON()
	Quit sc
}

ClassMethod RemoveCoffeemaker(id As %String) As %Status
{
	Set result={}
	Set sc=0
	
	if id'="",##class(Demo.coffeemaker).%ExistsId(id) {
	  Set sc=##class(Demo.coffeemaker).%DeleteId(id)
	  do result.%Set("Status",$s($$$ISERR(sc):$system.Status.GetOneErrorText(sc),1:"OK"))
	}
	else  {
	  do result.%Set("Status","")	
	}
	
	write result.%ToJSON()
	
  	quit sc
}

ClassMethod GetCoffeeMakerInfo(id As %String) As %Status
{
	Set coffeemaker = ##class(Demo.coffeemaker).%OpenId(id)
	If '$IsObject(coffeemaker) {
		Set %response.Status = ..#HTTP204NOCONTENT
	} Else {
		Set obj = {
			"img": (coffeemaker.Img),
			"coffeemakerID": (coffeemaker.CoffeemakerID),
			"name": 		(coffeemaker.Name),
			"brand":        (coffeemaker.Brand),
			"color":   		(coffeemaker.Color),
			"numcups":      (coffeemaker.NumCups),
			"price":        (coffeemaker.Price)
		}
		Write obj.%ToJSON()
	}
	Quit $$$OK
}

// HELPER METHODS

/// Helper method
ClassMethod ValidateJSON(obj As %DynamicObject, Output error As %DynamicObject) As %Boolean
{
	Set error = {}
	
	If obj.%Get("name") = "" {
		Set error.errormessage = "Name was blank"
		Quit 0
	}	
	
	If obj.%Get("brand") = "" {
		Set error.errormessage = "Brand was blank"
		Quit 0
	}
	
	Quit 1
}

/// Helper method
ClassMethod CopyToCoffeemakerFromJSON(ByRef cm As Demo.coffeemaker, obj As %DynamicObject) [ Private ]
{
	Set cm.Name=obj.name
	set cm.Brand = obj.brand
	Set cm.Img = obj.img
	set cm.Color = obj.color
	set cm.NumCups = obj.numcups
	set cm.Price = obj.price
}

/// Helper method
ClassMethod GetJSONFromRequest(Output obj As %DynamicObject) As %Boolean
{
	Set ok = 1
	Try {
		Set obj = ##class(%DynamicObject).%FromJSON(%request.Content)
	} Catch ex {
		Set ok = 0
	}
	Quit ok
}

}
