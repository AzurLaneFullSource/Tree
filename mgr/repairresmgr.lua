pg = pg or {}
pg.RepairResMgr = singletonClass("RepairResMgr")

local var0 = pg.RepairResMgr

var0.TYPE_DEFAULT_RES = 2
var0.TYPE_L2D = 4
var0.TYPE_PAINTING = 8
var0.TYPE_CIPHER = 16

function var0.Init(arg0, arg1)
	PoolMgr.GetInstance():GetUI("RepairUI", true, function(arg0)
		arg0._go = arg0
		arg0._tf = arg0._go.transform

		arg0._go:SetActive(false)

		arg0.contentTxt = arg0._tf:Find("window/content/Text"):GetComponent(typeof(Text))
		arg0.parentTr = pg.UIMgr.GetInstance().OverlayToast

		arg0._go.transform:SetParent(arg0.parentTr, false)

		arg0.closeBtn = arg0._tf:Find("window/top/btnBack")
		arg0.btns = {
			arg0:InitDefaultResBtn(),
			arg0:InitL2dBtn(),
			arg0:InitPaintingBtn(),
			arg0:InitCipherBtn()
		}
		arg0.uiItemList = UIItemList.New(arg0._tf:Find("window/buttons"), arg0._tf:Find("window/buttons/custom_button_1"))

		setText(arg0._tf:Find("window/top/title"), i18n("msgbox_repair_title"))
		arg1()
	end)
end

function var0.InitDefaultResBtn(arg0)
	return {
		type = var0.TYPE_DEFAULT_RES,
		text = i18n("msgbox_repair"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
				BundleWizard.Inst:GetGroupMgr("DEFAULT_RES"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0.InitL2dBtn(arg0)
	return {
		type = var0.TYPE_L2D,
		text = i18n("msgbox_repair_l2d"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-live2d.csv") then
				BundleWizard.Inst:GetGroupMgr("L2D"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0.InitPaintingBtn(arg0)
	return {
		type = var0.TYPE_PAINTING,
		text = i18n("msgbox_repair_painting"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-painting.csv") then
				BundleWizard.Inst:GetGroupMgr("PAINTING"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0.InitCipherBtn(arg0)
	return {
		type = var0.TYPE_CIPHER,
		text = i18n("msgbox_repair_cipher"),
		onCallback = function()
			if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-cipher.csv") then
				BundleWizard.Inst:GetGroupMgr("CIPHER"):StartVerifyForLua()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
			end
		end
	}
end

function var0.Repair(arg0, arg1)
	local var0 = arg1 or bit.bor(var0.TYPE_DEFAULT_RES, var0.TYPE_L2D, var0.TYPE_PAINTING, var0.TYPE_CIPHER)
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.btns) do
		if bit.band(iter1.type, var0) > 0 then
			table.insert(var1, iter1)
		end
	end

	arg0:Show(var1)
end

function var0.Show(arg0, arg1)
	pg.DelegateInfo.New(arg0)
	arg0._go:SetActive(true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	arg0.uiItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg1[arg1 + 1]

			setText(arg2:Find("Text"), var0.text)
			onButton(arg0, arg2, function()
				if var0.onCallback then
					var0.onCallback()
				end

				arg0:Hide()
			end, SFX_PANEL)
		end
	end)
	arg0.uiItemList:align(#arg1)

	arg0.contentTxt.text = i18n("resource_verify_warn")

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Hide(arg0)
	pg.DelegateInfo.Dispose(arg0)
	arg0._go:SetActive(false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0.parentTr)
end
