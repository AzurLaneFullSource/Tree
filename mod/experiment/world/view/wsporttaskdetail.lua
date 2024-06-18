local var0_0 = class("WSPortTaskDetail", import("...BaseEntity"))

var0_0.Fields = {
	task = "table",
	onCancel = "function",
	transform = "userdata"
}

function var0_0.Setup(arg0_1)
	pg.DelegateInfo.New(arg0_1)
	arg0_1:Init()
end

function var0_0.Dispose(arg0_2)
	pg.DelegateInfo.Dispose(arg0_2)
	arg0_2:Clear()
end

function var0_0.Init(arg0_3)
	local var0_3 = arg0_3.transform

	onButton(arg0_3, var0_3, function()
		arg0_3.onCancel()
	end, SFX_CANCEL)
	onButton(arg0_3, var0_3:Find("top/btnBack"), function()
		arg0_3.onCancel()
	end, SFX_CANCEL)
end

function var0_0.UpdateTask(arg0_6, arg1_6)
	arg0_6.task = arg1_6

	local var0_6 = arg0_6.transform

	setText(var0_6:Find("window/desc"), arg1_6.config.description)

	local var1_6 = arg1_6:GetDisplayDrops()
	local var2_6 = var0_6:Find("window/scrollview/list")
	local var3_6 = var0_6:Find("window/scrollview/item")
	local var4_6 = UIItemList.New(var2_6, var3_6)

	var4_6:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var1_6[arg1_7 + 1]

			updateDrop(arg2_7, var0_7)
			setScrollText(arg2_7:Find("name_mask/name"), var0_7:getConfig("name"))
		end
	end)
	var4_6:align(#var1_6)
end

return var0_0
