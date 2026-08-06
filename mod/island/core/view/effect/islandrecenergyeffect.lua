local var0_0 = class("IslandRecEnergyEffect")

var0_0.TYPE = 1

local var1_0 = 5
local var2_0 = Vector3(0, 2, 0)

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.root = arg1_1:Find("root")
	arg0_1.tpl = arg1_1:Find("tpls/RecEnergyTpl")

	setActive(arg0_1.tpl, false)

	arg0_1.pool = {}
	arg0_1.active = {}
end

function var0_0.GetType(arg0_2)
	return var0_0.TYPE
end

function var0_0.GetObject(arg0_3)
	local var0_3 = table.remove(arg0_3.pool)

	if not var0_3 or IsNil(var0_3) then
		var0_3 = Object.Instantiate(arg0_3.tpl.gameObject)
	end

	var0_3.transform:SetParent(arg0_3.root, false)

	local var1_3 = {
		expireTime = 0
	}

	arg0_3.active[var0_3] = var1_3

	setActive(var0_3, true)

	return var0_3, var1_3
end

function var0_0.Recycle(arg0_4, arg1_4)
	if not arg1_4 or IsNil(arg1_4) or not arg0_4.active or not arg0_4.active[arg1_4] then
		return
	end

	arg0_4.active[arg1_4] = nil

	setActive(arg1_4, false)
	arg1_4.transform:SetParent(arg0_4.root, false)

	arg1_4.transform.localPosition = Vector3.zero

	table.insert(arg0_4.pool, arg1_4)
end

function var0_0.GetLocalPosition(arg0_5, arg1_5)
	local var0_5 = arg1_5._go.transform.position + var2_0

	return IslandCalcUtil.WorldPosition2LocalPosition(arg0_5.root, var0_5), var0_5
end

function var0_0.Play(arg0_6, arg1_6, arg2_6)
	if not arg1_6 or not arg1_6._go then
		return
	end

	local var0_6, var1_6 = arg0_6:GetObject()

	var1_6.unit = arg1_6
	var1_6.expireTime = Time.time + var1_0

	local var2_6 = arg0_6:GetLocalPosition(arg1_6)

	var0_6.transform.localPosition = var2_6

	local var3_6 = var0_6.transform:Find("Text")

	if var3_6 then
		setText(var3_6, arg2_6 and arg2_6.value or 0)
	end
end

function var0_0.Update(arg0_7)
	for iter0_7, iter1_7 in pairs(arg0_7.active or {}) do
		local var0_7 = iter1_7.unit

		if IsNil(iter0_7) then
			arg0_7.active[iter0_7] = nil
		elseif Time.time >= iter1_7.expireTime or not var0_7 or IsNil(var0_7._go) then
			arg0_7:Recycle(iter0_7)
		else
			local var1_7, var2_7 = arg0_7:GetLocalPosition(var0_7)
			local var3_7 = IslandCalcUtil.IsInViewport(var2_7)

			setActive(iter0_7, var3_7)

			if var3_7 then
				iter0_7.transform.localPosition = var1_7
			end
		end
	end
end

function var0_0.Dispose(arg0_8)
	arg0_8.active = nil
	arg0_8.pool = nil
	arg0_8.root = nil
	arg0_8.tpl = nil
end

return var0_0
