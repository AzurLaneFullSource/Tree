local var0_0 = class("TouchCakeItem")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._cakeTf = findTF(arg0_1._tf, "cake")
	arg0_1._cakeAnimUI = GetComponent(arg0_1._cakeTf, typeof(SpineAnimUI))
	arg0_1._propLeftSpine = findTF(arg0_1._tf, "prop_left/spine")
	arg0_1._propLeftIcon = findTF(arg0_1._tf, "prop_left/icon")
	arg0_1._propLeftAnimUI = GetComponent(arg0_1._propLeftSpine, typeof(SpineAnimUI))
	arg0_1._propRightSpine = findTF(arg0_1._tf, "prop_right/spine")
	arg0_1._propRightIcon = findTF(arg0_1._tf, "prop_right/icon")
	arg0_1._propRightAnimUI = GetComponent(arg0_1._propRightSpine, typeof(SpineAnimUI))
	arg0_1._props = {
		{
			direct = -1,
			iconTf = arg0_1._propLeftIcon,
			spineTf = arg0_1._propLeftSpine,
			anim = arg0_1._propLeftAnimUI
		},
		{
			direct = 1,
			iconTf = arg0_1._propRightIcon,
			spineTf = arg0_1._propRightSpine,
			anim = arg0_1._propRightAnimUI
		}
	}
	arg0_1._eventCallback = arg2_1
end

function var0_0.setParent(arg0_2, arg1_2)
	SetParent(arg0_2._tf, arg1_2, true)
end

function var0_0.setPosition(arg0_3, arg1_3)
	arg0_3._tf.anchoredPosition = arg1_3
end

function var0_0.setData(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4._cakeData = arg1_4

	for iter0_4, iter1_4 in ipairs(arg0_4._props) do
		iter1_4.data = nil
	end

	if arg2_4 then
		local var0_4

		if not arg3_4 then
			var0_4 = arg0_4._props[math.random(1, #arg0_4._props)]
		else
			for iter2_4, iter3_4 in ipairs(arg0_4._props) do
				if iter3_4.direct == arg3_4 then
					var0_4 = iter3_4
				end
			end
		end

		var0_4.data = arg2_4
	end

	arg0_4:updateItem()
end

function var0_0.updateItem(arg0_5)
	local var0_5 = arg0_5:getCakeAnimName(TouchCakeGameConst.cake_anim_normal)

	arg0_5:setAniamtion(arg0_5._cakeAnimUI, var0_5)

	for iter0_5, iter1_5 in ipairs(arg0_5._props) do
		setActive(iter1_5.spineTf, false)
		setActive(iter1_5.iconTf, false)

		if iter1_5.data then
			setActive(iter1_5.spineTf, iter1_5.data.spine and true or false)
			setActive(iter1_5.iconTf, iter1_5.data.icon and true or false)

			if iter1_5.data.spine then
				local var1_5
				local var2_5
				local var3_5, var4_5 = arg0_5:getPropAnimName(TouchCakeGameConst.prop_anim_normal, iter1_5.data)

				iter1_5.spineTf.localScale = Vector3(var4_5, 1, 1)

				arg0_5:setAniamtion(iter1_5.anim, var3_5)
			elseif iter1_5.data.icon then
				arg0_5:setIconVisible(iter1_5.iconTf, iter1_5.data.icon)
			end
		end
	end
end

function var0_0.setIconVisible(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6.childCount

	for iter0_6 = 1, var0_6 do
		local var1_6 = arg1_6:GetChild(iter0_6 - 1)

		setActive(var1_6, var1_6.name == arg2_6)
	end
end

function var0_0.touchAction(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7:getCakeAnimName(TouchCakeGameConst.cake_anim_action, arg1_7)

	arg0_7:setAniamtion(arg0_7._cakeAnimUI, var0_7, arg2_7)
	arg0_7._eventCallback(TouchCakeScene.EVENT_ACTION_CAKE, {
		cake = Clone(arg0_7._cakeData)
	})
end

function var0_0.getCakeAnimName(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8:getCakeConfig("type")

	if arg1_8 == TouchCakeGameConst.cake_anim_normal then
		return "normal" .. var0_8
	elseif arg1_8 == TouchCakeGameConst.cake_anim_action then
		local var1_8 = arg2_8

		if var1_8 == 1 then
			return "action_left_" .. var0_8
		elseif var1_8 == -1 then
			return "action_right_" .. var0_8
		end
	end
end

function var0_0.getPropAnimName(arg0_9, arg1_9, arg2_9, arg3_9)
	local var0_9 = arg2_9.type

	if arg1_9 == TouchCakeGameConst.prop_anim_normal then
		return "normal" .. var0_9, 1
	elseif arg1_9 == TouchCakeGameConst.prop_anim_action then
		if var0_9 == 4 then
			if arg3_9 == 1 then
				return "action" .. var0_9, 1
			else
				return "action" .. var0_9 .. "_left", -1
			end
		end

		return "action" .. var0_9, 1
	end
end

function var0_0.getCakeConfig(arg0_10, arg1_10)
	return arg0_10._cakeData[arg1_10]
end

function var0_0.getPropConfig(arg0_11, arg1_11)
	return arg0_11._propData[arg1_11]
end

function var0_0.getTopPos(arg0_12)
	local var0_12 = arg0_12._tf.anchoredPosition

	var0_12.y = var0_12.y + arg0_12:getCakeConfig("height")

	return var0_12
end

function var0_0.setLayerLast(arg0_13)
	arg0_13._tf:SetAsLastSibling()
end

function var0_0.setLayerFirst(arg0_14)
	arg0_14._tf:SetAsFirstSibling()
end

function var0_0.getPropDirect(arg0_15)
	for iter0_15, iter1_15 in ipairs(arg0_15._props) do
		if iter1_15.data ~= nil then
			return iter1_15.direct
		end
	end

	return nil
end

function var0_0.setAniamtion(arg0_16, arg1_16, arg2_16, arg3_16)
	arg1_16:SetActionCallBack(nil)
	arg1_16:SetAction(arg2_16, 0)
	arg1_16:SetActionCallBack(function(arg0_17)
		if arg0_17 == "finish" then
			arg1_16:SetActionCallBack(nil)

			if arg3_16 then
				arg3_16()
			end
		end
	end)
end

function var0_0.stop(arg0_18)
	if isActive(arg0_18._cakeTf) then
		arg0_18._cakeAnimUI:Pause()
	end

	for iter0_18, iter1_18 in ipairs(arg0_18._props) do
		if iter1_18.spineTf and isActive(iter1_18.spineTf) and iter1_18.anim then
			iter1_18.anim:Pause()
		end
	end
end

function var0_0.resume(arg0_19)
	if isActive(arg0_19._cakeTf) then
		arg0_19._cakeAnimUI:Resume()
	end

	for iter0_19, iter1_19 in ipairs(arg0_19._props) do
		if iter1_19.spineTf and isActive(iter1_19.spineTf) and iter1_19.anim then
			iter1_19.anim:Resume()
		end
	end
end

function var0_0.propAction(arg0_20)
	for iter0_20, iter1_20 in ipairs(arg0_20._props) do
		if iter1_20.data then
			arg0_20._eventCallback(TouchCakeScene.EVENT_ACTION_PROP, {
				prop = Clone(iter1_20)
			}, function(arg0_21)
				if iter1_20.data.spine then
					local var0_21
					local var1_21
					local var2_21, var3_21 = arg0_20:getPropAnimName(TouchCakeGameConst.prop_anim_action, iter1_20.data, iter1_20.direct)

					iter1_20.spineTf.localScale = Vector3(var3_21, 1, 1)

					arg0_20:setAniamtion(iter1_20.anim, var2_21, function()
						setActive(iter1_20.spineTf, false)
					end)
				elseif iter1_20.data.icon then
					setActive(iter1_20.iconTf, false)
				end
			end)
		end
	end
end

function var0_0.clear(arg0_23)
	return
end

return var0_0
