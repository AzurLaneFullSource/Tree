local var0 = class("PropertyPanel")
local var1 = 24.5
local var2 = {
	"cannon",
	"torpedo",
	"air",
	"dodge",
	"antiaircraft",
	"durability"
}
local var3 = {
	E = 1,
	C = 3,
	A = 5,
	D = 2,
	S = 6,
	B = 4
}
local var4 = {
	{
		0,
		70.8
	},
	{
		-169.6,
		37.7
	},
	{
		-210.4,
		-49.8
	},
	{
		-0.9,
		-111.1
	},
	{
		210.1,
		-49.6
	},
	{
		169.9,
		38.4
	}
}
local var5 = 1
local var6 = 3
local var7 = 4
local var8 = 2
local var9 = 5

var0.TypeRotation = 1
var0.TypeFlat = 2

function var0.Ctor(arg0, arg1, arg2)
	var1 = arg2 or var1
	arg0.tf = arg1
	arg0.propertyTFs = findTF(arg0.tf, "property")
	arg0.drawTF = findTF(arg0.tf, "property/draw")
	arg0.drawPolygon = arg0.drawTF:GetComponent("DrawPolygon")
	arg0.drawTF2 = findTF(arg0.tf, "property/draw_2")

	if arg0.drawTF2 then
		arg0.drawPolygon2 = arg0.drawTF2:GetComponent("DrawPolygon")
	end
end

function var0.initProperty(arg0, arg1, arg2)
	arg0.type = arg2 or var0.TypeRotation

	local var0 = Ship.getGroupIdByConfigId(arg1)
	local var1 = ShipGroup.GetGroupConfig(var0).property_hexagon

	arg0:initRadar(var1)
end

function var0.initRadar(arg0, arg1)
	local var0 = {}
	local var1 = {}

	table.insert(var0, Vector3(0, 0, 0))

	for iter0, iter1 in ipairs(var2) do
		local var2 = arg0.propertyTFs:Find(iter1 .. "_grade")
		local var3 = arg1[iter0]

		arg0:setSpriteTo("resources/" .. var3, var2:Find("grade"), true)

		if arg0.type == var0.TypeRotation then
			table.insert(var0, arg0:getGradeCoordinate(var3, iter0))
		elseif arg0.type == var0.TypeFlat then
			table.insert(var0, arg0:getGradeCoordinate1(var3, iter0))
		end

		table.insert(var1, 0)
		table.insert(var1, iter0)

		if iter0 + 1 > #var2 then
			table.insert(var1, 1)
		else
			table.insert(var1, iter0 + 1)
		end

		if findTF(var2, "Text") and findTF(var2, "Text"):GetComponent(typeof(Text)) then
			setText(findTF(var2, "Text"), i18n("word_attr_" .. iter1))
		end
	end

	arg0.drawPolygon:draw(var0, var1)

	if arg0.drawPolygon2 then
		arg0.drawPolygon2:draw(var0, var1)
	end
end

function var0.getGradeCoordinate(arg0, arg1, arg2)
	local var0 = 0.163 * var3[arg1] * var4[arg2][1]
	local var1 = 0.163 * var3[arg1] * var4[arg2][2]

	return Vector3(var0, var1, 0)
end

function var0.getGradeCoordinate1(arg0, arg1, arg2)
	local var0 = 0.66 * var3[arg1]

	if arg2 == var8 then
		return Vector3(-var0 * var1, 0, 0)
	elseif arg2 == var9 then
		return Vector3(var0 * var1, 0, 0)
	else
		local var1 = 60
		local var2 = var0 * var1
		local var3 = math.sin(math.rad(var1)) * var2
		local var4 = math.cos(math.rad(var1)) * var2

		if arg2 == var5 then
			var4 = -var4
		elseif arg2 == var6 then
			var4 = -var4
			var3 = -var3
		elseif arg2 == var7 then
			var3 = -var3
		end

		return Vector3(var4, var3, 0)
	end
end

function var0.setSpriteTo(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(Image))

	var0.sprite = findTF(arg0.tf, arg1):GetComponent(typeof(Image)).sprite

	if arg3 then
		var0:SetNativeSize()
	end
end

return var0
