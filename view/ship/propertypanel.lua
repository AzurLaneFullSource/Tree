local var0_0 = class("PropertyPanel")
local var1_0 = 24.5
local var2_0 = {
	"cannon",
	"torpedo",
	"air",
	"dodge",
	"antiaircraft",
	"durability"
}
local var3_0 = {
	E = 1,
	C = 3,
	A = 5,
	D = 2,
	S = 6,
	B = 4
}
local var4_0 = {
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
local var5_0 = 1
local var6_0 = 3
local var7_0 = 4
local var8_0 = 2
local var9_0 = 5

var0_0.TypeRotation = 1
var0_0.TypeFlat = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0 = arg2_1 or var1_0
	arg0_1.tf = arg1_1
	arg0_1.propertyTFs = findTF(arg0_1.tf, "property")
	arg0_1.drawTF = findTF(arg0_1.tf, "property/draw")
	arg0_1.drawPolygon = arg0_1.drawTF:GetComponent("DrawPolygon")
	arg0_1.drawTF2 = findTF(arg0_1.tf, "property/draw_2")

	if arg0_1.drawTF2 then
		arg0_1.drawPolygon2 = arg0_1.drawTF2:GetComponent("DrawPolygon")
	end
end

function var0_0.initProperty(arg0_2, arg1_2, arg2_2)
	arg0_2.type = arg2_2 or var0_0.TypeRotation

	local var0_2 = Ship.getGroupIdByConfigId(arg1_2)
	local var1_2 = ShipGroup.GetGroupConfig(var0_2).property_hexagon

	arg0_2:initRadar(var1_2)
end

function var0_0.initRadar(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = {}

	table.insert(var0_3, Vector3(0, 0, 0))

	for iter0_3, iter1_3 in ipairs(var2_0) do
		local var2_3 = arg0_3.propertyTFs:Find(iter1_3 .. "_grade")
		local var3_3 = arg1_3[iter0_3]

		arg0_3:setSpriteTo("resources/" .. var3_3, var2_3:Find("grade"), true)

		if arg0_3.type == var0_0.TypeRotation then
			table.insert(var0_3, arg0_3:getGradeCoordinate(var3_3, iter0_3))
		elseif arg0_3.type == var0_0.TypeFlat then
			table.insert(var0_3, arg0_3:getGradeCoordinate1(var3_3, iter0_3))
		end

		table.insert(var1_3, 0)
		table.insert(var1_3, iter0_3)

		if iter0_3 + 1 > #var2_0 then
			table.insert(var1_3, 1)
		else
			table.insert(var1_3, iter0_3 + 1)
		end

		if findTF(var2_3, "Text") and findTF(var2_3, "Text"):GetComponent(typeof(Text)) then
			setText(findTF(var2_3, "Text"), i18n("word_attr_" .. iter1_3))
		end
	end

	arg0_3.drawPolygon:draw(var0_3, var1_3)

	if arg0_3.drawPolygon2 then
		arg0_3.drawPolygon2:draw(var0_3, var1_3)
	end
end

function var0_0.getGradeCoordinate(arg0_4, arg1_4, arg2_4)
	local var0_4 = 0.163 * var3_0[arg1_4] * var4_0[arg2_4][1]
	local var1_4 = 0.163 * var3_0[arg1_4] * var4_0[arg2_4][2]

	return Vector3(var0_4, var1_4, 0)
end

function var0_0.getGradeCoordinate1(arg0_5, arg1_5, arg2_5)
	local var0_5 = 0.66 * var3_0[arg1_5]

	if arg2_5 == var8_0 then
		return Vector3(-var0_5 * var1_0, 0, 0)
	elseif arg2_5 == var9_0 then
		return Vector3(var0_5 * var1_0, 0, 0)
	else
		local var1_5 = 60
		local var2_5 = var0_5 * var1_0
		local var3_5 = math.sin(math.rad(var1_5)) * var2_5
		local var4_5 = math.cos(math.rad(var1_5)) * var2_5

		if arg2_5 == var5_0 then
			var4_5 = -var4_5
		elseif arg2_5 == var6_0 then
			var4_5 = -var4_5
			var3_5 = -var3_5
		elseif arg2_5 == var7_0 then
			var3_5 = -var3_5
		end

		return Vector3(var4_5, var3_5, 0)
	end
end

function var0_0.setSpriteTo(arg0_6, arg1_6, arg2_6, arg3_6)
	local var0_6 = arg2_6:GetComponent(typeof(Image))

	var0_6.sprite = findTF(arg0_6.tf, arg1_6):GetComponent(typeof(Image)).sprite

	if arg3_6 then
		var0_6:SetNativeSize()
	end
end

return var0_0
