/// Use or operation of this code is subject to acceptance of the license available in the code repository for this code.
/// 
Class Demo.coffeemaker Extends (%Persistent, %Populate, %XML.Adaptor) [ Owner = {%DB_COFFEE} ]
{

Property CoffeemakerID As %Integer [ Calculated, SqlComputeCode = {Set {*} = {ID} }, SqlComputed ];

Property Name As %String [ Required ];

Property Brand As %String [ Required ];

Property Color As %String;

Property NumCups As %Integer(VALUELIST = ",1,2,3,4,8,12,16,32,64");

Property Price As %Numeric(SCALE = 2);

Property Img As %String(MAXLEN = 256) [ InitialExpression = "test-redphone.png" ];

Method ToJSON() As %String
{
	set obj = {}
	set obj.CoffeemakerID = ..CoffeemakerID
	set obj.Name = ..Name
	set obj.Brand = ..Brand
	set obj.Color = ..Color
	set obj.NumCups = ..NumCups
	set obj.Price = ..Price
	set obj.Img = ..Img
	set string = obj.%ToJSON()
	quit string
}

Storage Default
{
<Data name="coffeemakerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CoffeemakerID</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Brand</Value>
</Value>
<Value name="5">
<Value>Color</Value>
</Value>
<Value name="6">
<Value>NumCups</Value>
</Value>
<Value name="7">
<Value>Price</Value>
</Value>
<Value name="8">
<Value>Img</Value>
</Value>
</Data>
<DataLocation>^Demo.coffeemakerD</DataLocation>
<DefaultData>coffeemakerDefaultData</DefaultData>
<ExtentSize>10</ExtentSize>
<IdLocation>^Demo.coffeemakerD</IdLocation>
<IndexLocation>^Demo.coffeemakerI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>1.1</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="Brand">
<AverageFieldSize>4.8</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="CoffeeMakerID">
<AverageFieldSize>1.1</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="Color">
<AverageFieldSize>4.7</AverageFieldSize>
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="ID">
<AverageFieldSize>8.8</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="Img">
<AverageFieldSize>5</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="Name">
<AverageFieldSize>15.7</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<Property name="NumCups">
<AverageFieldSize>1.3</AverageFieldSize>
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="Price">
<AverageFieldSize>6.8</AverageFieldSize>
<Selectivity>10.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-4</BlockCount>
</SQLMap>
<StreamLocation>^Demo.coffeemakerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
