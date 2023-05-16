/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// 
Class Demo.MyFunctions
{

ClassMethod ToJSON(id As %String) As %String
{
		set JSONstring = ##class(Demo.coffeemaker).%OpenId(id).ToJSON()
		quit JSONstring
}

ClassMethod GetAllCoffeemakers() As %String
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
	
	quit tArr.%ToJSON()
}

ClassMethod DeleteMaker(id As %String) As %String
{
	set status = ##class(Demo.coffeemaker).%DeleteId(id)
	set response = {}
	if status = $$$OK
	{
		do response.%Set("message","Coffeemaker with id "_id_" has been deleted.")
	}
	else 
	{
		do response.%Set("message","Deletion failed. Likely no coffeemaker with id "_id)
	}
	quit response.%ToJSON()
}

ClassMethod NewMaker(Payload As Demo.tempCoffeemaker) As %String
{
	Set cm = ##class(Demo.coffeemaker).%New()
	Do ..CopyToCoffeemakerFromJSON(.cm,Payload)
	
	Set sc = cm.%Save()
	
	Set result={}
	do result.%Set("Status",$s($$$ISERR(sc):$system.Status.GetOneErrorText(sc),1:"OK"))
	if '$$$ISERR(sc) do result.%Set("Message","New maker saved with ID "_cm.%Id())
	quit result.%ToJSON()
}

ClassMethod EditMaker(id As %String, Payload As Demo.tempCoffeemaker) As %String
{
	Set cm = ##class(Demo.coffeemaker).%OpenId(id)
	If '$IsObject(cm) {
		Set error = {"errormessage": "Coffee maker does not exist"}
		Quit error.%ToJSON()
	}
	
	Do ..CopyToCoffeemakerFromJSON(.cm,Payload)
				
	Set sc = cm.%Save()

	Set result={}
	do result.%Set("Status",$s($$$ISERR(sc):$system.Status.GetOneErrorText(sc),1:"OK"))
	if '$$$ISERR(sc) do result.%Set("Message","Maker with ID "_cm.%Id()_" has been updated")
	quit result.%ToJSON()
}

ClassMethod CopyToCoffeemakerFromJSON(ByRef cm As Demo.coffeemaker, obj As Demo.tempCoffeemaker)
{
	Set cm.Name= obj.Name
	set cm.Brand = obj.Brand
	Set cm.Img = obj.Img
	set cm.Color = obj.Color
	set cm.NumCups = obj.NumCups
	set cm.Price = obj.Price
}

}
