local var0_0 = class("MetaSkillUnlockPanel", import(".MsgboxSubPanel"))

function var0_0.getUIName(arg0_1)
	return "MetaSkillUnlockBox"
end

function var0_0.OnInit(arg0_2)
	arg0_2:findUI()
	arg0_2:initData()
	arg0_2:addListener()
end

function var0_0.UpdateView(arg0_3, arg1_3)
	arg0_3:PreRefresh(arg1_3)
	arg0_3:updateContent(arg1_3)

	rtf(arg0_3.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	arg0_3:PostRefresh(arg1_3)
end

function var0_0.findUI(arg0_4)
	arg0_4.tipText = arg0_4:findTF("Tip")
	arg0_4.materialTpl = arg0_4:findTF("Material")
	arg0_4.materialContainer = arg0_4:findTF("MaterialContainer")
	arg0_4.uiItemList = UIItemList.New(arg0_4.materialContainer, arg0_4.materialTpl)
	arg0_4.cancelBtn = arg0_4:findTF("Buttons/CancelBtn")
	arg0_4.confirmBtn = arg0_4:findTF("Buttons/ConfirmBtn")

	local var0_4 = arg0_4:findTF("Text", arg0_4.cancelBtn)
	local var1_4 = arg0_4:findTF("Text", arg0_4.confirmBtn)

	setText(var0_4, i18n("word_cancel"))
	setText(var1_4, i18n("word_ok"))
end

function var0_0.initData(arg0_5)
	arg0_5.curMetaShipID = nil
	arg0_5.curUnlockSkillID = nil
	arg0_5.curUnlockMaterialID = nil
	arg0_5.curUnlockMaterialNeedCount = nil
end

function var0_0.addListener(arg0_6)
	onButton(arg0_6, arg0_6.confirmBtn, function()
		if not arg0_6.curUnlockMaterialID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_unlock_skill_select"))

			return
		elseif getProxy(BagProxy):getItemCountById(arg0_6.curUnlockMaterialID) < arg0_6.curUnlockMaterialNeedCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var0_7 = 0
			local var1_7 = 0
			local var2_7 = MetaCharacterConst.getMetaSkillTacticsConfig(arg0_6.curUnlockSkillID, 1).skill_unlock

			for iter0_7, iter1_7 in ipairs(var2_7) do
				if arg0_6.curUnlockMaterialID == iter1_7[2] then
					var0_7 = iter0_7
					var1_7 = iter1_7[3]

					break
				end
			end

			pg.m02:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL, {
				shipID = arg0_6.curMetaShipID,
				skillID = arg0_6.curUnlockSkillID,
				materialIndex = var0_7,
				materialInfo = {
					id = arg0_6.curUnlockMaterialID,
					count = var1_7
				}
			})
		end

		pg.MsgboxMgr.GetInstance():hide()
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.cancelBtn, function()
		pg.MsgboxMgr.GetInstance():hide()
	end, SFX_CANCEL)
end

function var0_0.updateContent(arg0_9, arg1_9)
	local var0_9 = arg1_9.metaShipVO
	local var1_9 = var0_9:getMetaCharacter()

	arg0_9.curMetaShipID = var0_9.id

	local var2_9 = arg1_9.skillID

	arg0_9.curUnlockSkillID = var2_9

	local var3_9 = ShipGroup.getDefaultShipNameByGroupID(var1_9.id)
	local var4_9 = getSkillName(var2_9)

	setText(arg0_9.tipText, i18n("meta_unlock_skill_tip", var3_9, var4_9))

	local var5_9 = MetaCharacterConst.getMetaSkillTacticsConfig(var2_9, 1)
	local var6_9 = var5_9.skill_unlock
	local var7_9 = {
		var5_9.skill_unlock[1]
	}

	arg0_9.uiItemList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			arg1_10 = arg1_10 + 1

			local var0_10 = var7_9[arg1_10]
			local var1_10 = arg0_9:findTF("Item", arg2_10)
			local var2_10 = arg0_9:findTF("SelectedTag", arg2_10)
			local var3_10 = arg0_9:findTF("Count/Text", arg2_10)
			local var4_10 = {
				type = DROP_TYPE_ITEM,
				id = var0_10[2],
				count = var0_10[3]
			}

			updateDrop(var1_10, var4_10)
			setActive(var2_10, false)

			local var5_10 = var0_10[2]
			local var6_10 = var0_10[3]
			local var7_10 = getProxy(BagProxy):getItemCountById(var5_10)
			local var8_10 = var7_10 < var6_10 and setColorStr(var7_10, COLOR_RED) or setColorStr(var7_10, COLOR_GREEN)

			setText(var3_10, var8_10 .. "/" .. var6_10)

			arg0_9.curUnlockMaterialID = var5_10
			arg0_9.curUnlockMaterialNeedCount = var6_10
		end
	end)
	arg0_9.uiItemList:align(#var7_9)
end

return var0_0
