pg = pg or {}

local var0_0 = pg
local var1_0 = class("ViewUtils")

var0_0.ViewUtils = var1_0

function var1_0.SetLayer(arg0_1, arg1_1)
	if IsNil(go(arg0_1)) then
		return
	end

	go(arg0_1).layer = arg1_1

	local var0_1 = arg0_1.childCount

	for iter0_1 = 0, var0_1 - 1 do
		var1_0.SetLayer(arg0_1:GetChild(iter0_1), arg1_1)
	end
end

function var1_0.SetSortingOrder(arg0_2, arg1_2)
	arg0_2 = tf(arg0_2)

	local var0_2 = arg0_2:GetComponents(typeof(Renderer))

	for iter0_2 = 0, var0_2.Length - 1 do
		var0_2[iter0_2].sortingOrder = arg1_2
	end

	local var1_2 = arg0_2:GetComponent(typeof(Canvas))

	if var1_2 then
		var1_2.sortingOrder = arg1_2
	end

	for iter1_2 = 0, arg0_2.childCount - 1 do
		var1_0.SetSortingOrder(arg0_2:GetChild(iter1_2), arg1_2)
	end
end

function var1_0.AddSortingOrder(arg0_3, arg1_3)
	arg0_3 = tf(arg0_3)

	local var0_3 = arg0_3:GetComponents(typeof(Renderer))

	for iter0_3 = 0, var0_3.Length - 1 do
		var0_3[iter0_3].sortingOrder = var0_3[iter0_3].sortingOrder + arg1_3
	end

	local var1_3 = arg0_3:GetComponent(typeof(Canvas))

	if var1_3 then
		var1_3.sortingOrder = var1_3.sortingOrder + arg1_3
	end

	for iter1_3 = 0, arg0_3.childCount - 1 do
		var1_0.AddSortingOrder(arg0_3:GetChild(iter1_3), arg1_3)
	end
end
