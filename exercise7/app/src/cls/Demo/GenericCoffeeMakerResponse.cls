/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// 
Class Demo.GenericCoffeeMakerResponse
{

Property JSONResponse As %String(MAXLEN = 5000);

Storage Default
{
<Data name="GenericCoffeeMakerResponseDefaultData">
<Subscript>"GenericCoffeeMakerResponse"</Subscript>
<Value name="1">
<Value>JSONResponse</Value>
</Value>
</Data>
<DefaultData>GenericCoffeeMakerResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
