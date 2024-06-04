pg = pg or {}

local var0 = pg
local var1 = class("ViewUtils")

var0.ViewUtils = var1

function var1.SetLayer(arg0, arg1)
	if IsNil(go(arg0)) then
		return
	end

	go(arg0).layer = arg1

	local var0 = arg0.childCount

	for iter0 = 0, var0 - 1 do
		var1.SetLayer(arg0:GetChild(iter0), arg1)
	end
end

function var1.SetSortingOrder(arg0, arg1)
	arg0 = tf(arg0)

	local var0 = arg0:GetComponents(typeof(Renderer))

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].sortingOrder = arg1
	end

	local var1 = arg0:GetComponent(typeof(Canvas))

	if var1 then
		var1.sortingOrder = arg1
	end

	for iter1 = 0, arg0.childCount - 1 do
		var1.SetSortingOrder(arg0:GetChild(iter1), arg1)
	end
end

function var1.AddSortingOrder(arg0, arg1)
	arg0 = tf(arg0)

	local var0 = arg0:GetComponents(typeof(Renderer))

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].sortingOrder = var0[iter0].sortingOrder + arg1
	end

	local var1 = arg0:GetComponent(typeof(Canvas))

	if var1 then
		var1.sortingOrder = var1.sortingOrder + arg1
	end

	for iter1 = 0, arg0.childCount - 1 do
		var1.AddSortingOrder(arg0:GetChild(iter1), arg1)
	end
end
