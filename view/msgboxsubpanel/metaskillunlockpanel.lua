local var0 = class("MetaSkillUnlockPanel", import(".MsgboxSubPanel"))

function var0.getUIName(arg0)
	return "MetaSkillUnlockBox"
end

function var0.OnInit(arg0)
	arg0:findUI()
	arg0:initData()
	arg0:addListener()
end

function var0.UpdateView(arg0, arg1)
	arg0:PreRefresh(arg1)
	arg0:updateContent(arg1)

	rtf(arg0.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	arg0:PostRefresh(arg1)
end

function var0.findUI(arg0)
	arg0.tipText = arg0:findTF("Tip")
	arg0.materialTpl = arg0:findTF("Material")
	arg0.materialContainer = arg0:findTF("MaterialContainer")
	arg0.uiItemList = UIItemList.New(arg0.materialContainer, arg0.materialTpl)
	arg0.cancelBtn = arg0:findTF("Buttons/CancelBtn")
	arg0.confirmBtn = arg0:findTF("Buttons/ConfirmBtn")

	local var0 = arg0:findTF("Text", arg0.cancelBtn)
	local var1 = arg0:findTF("Text", arg0.confirmBtn)

	setText(var0, i18n("word_cancel"))
	setText(var1, i18n("word_ok"))
end

function var0.initData(arg0)
	arg0.curMetaShipID = nil
	arg0.curUnlockSkillID = nil
	arg0.curUnlockMaterialID = nil
	arg0.curUnlockMaterialNeedCount = nil
end

function var0.addListener(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		if not arg0.curUnlockMaterialID then
			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_unlock_skill_select"))

			return
		elseif getProxy(BagProxy):getItemCountById(arg0.curUnlockMaterialID) < arg0.curUnlockMaterialNeedCount then
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))
		else
			local var0 = 0
			local var1 = 0
			local var2 = MetaCharacterConst.getMetaSkillTacticsConfig(arg0.curUnlockSkillID, 1).skill_unlock

			for iter0, iter1 in ipairs(var2) do
				if arg0.curUnlockMaterialID == iter1[2] then
					var0 = iter0
					var1 = iter1[3]

					break
				end
			end

			pg.m02:sendNotification(GAME.TACTICS_META_UNLOCK_SKILL, {
				shipID = arg0.curMetaShipID,
				skillID = arg0.curUnlockSkillID,
				materialIndex = var0,
				materialInfo = {
					id = arg0.curUnlockMaterialID,
					count = var1
				}
			})
		end

		pg.MsgboxMgr.GetInstance():hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		pg.MsgboxMgr.GetInstance():hide()
	end, SFX_CANCEL)
end

function var0.updateContent(arg0, arg1)
	local var0 = arg1.metaShipVO
	local var1 = var0:getMetaCharacter()

	arg0.curMetaShipID = var0.id

	local var2 = arg1.skillID

	arg0.curUnlockSkillID = var2

	local var3 = ShipGroup.getDefaultShipNameByGroupID(var1.id)
	local var4 = getSkillName(var2)

	setText(arg0.tipText, i18n("meta_unlock_skill_tip", var3, var4))

	local var5 = MetaCharacterConst.getMetaSkillTacticsConfig(var2, 1)
	local var6 = var5.skill_unlock
	local var7 = {
		var5.skill_unlock[1]
	}

	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = var7[arg1]
			local var1 = arg0:findTF("Item", arg2)
			local var2 = arg0:findTF("SelectedTag", arg2)
			local var3 = arg0:findTF("Count/Text", arg2)
			local var4 = {
				type = DROP_TYPE_ITEM,
				id = var0[2],
				count = var0[3]
			}

			updateDrop(var1, var4)
			setActive(var2, false)

			local var5 = var0[2]
			local var6 = var0[3]
			local var7 = getProxy(BagProxy):getItemCountById(var5)
			local var8 = var7 < var6 and setColorStr(var7, COLOR_RED) or setColorStr(var7, COLOR_GREEN)

			setText(var3, var8 .. "/" .. var6)

			arg0.curUnlockMaterialID = var5
			arg0.curUnlockMaterialNeedCount = var6
		end
	end)
	arg0.uiItemList:align(#var7)
end

return var0
