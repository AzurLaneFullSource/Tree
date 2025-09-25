local var0_0 = class("IslandDressupNpcUnit", import(".IslandNpcUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.SetShipDressHelper(arg0_2, arg1_2)
	arg0_2.shipDressHelper = arg1_2
end

function var0_0.OnDetach(arg0_3)
	if arg0_3.shipDressHelper then
		arg0_3.shipDressHelper:Destroy()
	end
end

function var0_0.OnCharacterChangeDress(arg0_4, arg1_4, arg2_4, arg3_4)
	if arg1_4 then
		local var0_4 = {}

		local function var1_4()
			arg0_4._animator = arg0_4._tf:GetChild(0):GetComponent(typeof(Animator))

			for iter0_5, iter1_5 in ipairs(var0_4) do
				arg0_4._animator:Play(iter1_5.shortNameHash, iter0_5 - 1, iter1_5.normalizedTime)
			end

			arg0_4._tf:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)):StartBehaviour()
		end

		arg0_4._tf:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)):PauseBehaviour()

		local var2_4 = 0

		normalizedTime = arg0_4._animator:GetCurrentAnimatorStateInfo(var2_4).normalizedTime % 1

		for iter0_4 = 1, arg0_4._animator.layerCount do
			local var3_4 = iter0_4 - 1
			local var4_4 = arg0_4._animator:GetCurrentAnimatorStateInfo(var3_4)

			table.insert(var0_4, {
				shortNameHash = var4_4.shortNameHash,
				normalizedTime = var4_4.normalizedTime
			})
		end

		arg0_4:DestroyInteractiveTools()

		arg0_4._animator = nil

		if #arg2_4 == 0 and #arg3_4 == 0 then
			arg0_4.shipDressHelper:ChangeModelTransfromByUnitId(arg1_4, var1_4)
		else
			arg0_4.shipDressHelper:ChangeModelTransfromByUnitIdAndChangeDress(arg1_4, arg2_4, arg3_4, var1_4)
		end
	else
		for iter1_4, iter2_4 in ipairs(arg2_4) do
			local var5_4 = pg.island_dress_template[iter2_4].type

			arg0_4.shipDressHelper:ChangeDressByType(var5_4, {
				id = 0,
				colorId = 0
			})
		end

		for iter3_4, iter4_4 in ipairs(arg3_4) do
			local var6_4 = pg.island_dress_template[iter4_4].type

			arg0_4.shipDressHelper:ChangeDressByType(var6_4, {
				colorId = 0,
				id = iter4_4
			})
		end
	end
end

return var0_0
