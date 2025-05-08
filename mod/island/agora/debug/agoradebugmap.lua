local var0_0 = class("AgoraDebugMap", import("Mod.Island.Core.View.IslandBaseSubView"))
local var1_0 = Color.New(1, 0, 0, 1)
local var2_0 = Color.New(0, 1, 0, 1)

function var0_0.GetUIName(arg0_1)
	return "IslandAgoraDebugUI"
end

function var0_0.OnInit(arg0_2, arg1_2)
	arg0_2._go = arg1_2

	setParent(arg1_2, pg.UIMgr.GetInstance().UIMain)

	arg0_2.tpl = arg1_2.transform:Find("Image")
	arg0_2.items = {}
	arg0_2.isInited = false

	arg0_2:GenMap(arg0_2.view.agora.map)
end

function var0_0.GenMap(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = 0

	for iter0_3, iter1_3 in pairs(arg1_3) do
		for iter2_3, iter3_3 in pairs(iter1_3) do
			table.insert(var0_3, function(arg0_4)
				var1_3 = var1_3 + 1

				if arg0_3.exited then
					arg0_4()

					return
				end

				arg0_3:CreateItem({
					position = Vector2(iter0_3, iter2_3),
					flag = iter3_3
				})

				if var1_3 % 50 == 0 then
					onNextTick(arg0_4)
				else
					arg0_4()
				end
			end)
		end
	end

	seriesAsync(var0_3, function()
		arg0_3.isInited = true

		arg0_3:FlushAll(arg1_3)
	end)
end

function var0_0.FlushAll(arg0_6, arg1_6)
	for iter0_6, iter1_6 in pairs(arg1_6) do
		for iter2_6, iter3_6 in pairs(iter1_6) do
			arg0_6:UpdateItem(Vector2(iter0_6, iter2_6), iter3_6)
		end
	end
end

function var0_0.CreateItem(arg0_7, arg1_7)
	local var0_7 = cloneTplTo(arg0_7.tpl, arg0_7.tpl.transform.parent)

	var0_7.name = arg1_7.position.x .. "_" .. arg1_7.position.y

	local var1_7 = Vector3(10, 10, 0)

	var0_7.transform.localPosition = Vector3(arg1_7.position.x * var1_7.x, arg1_7.position.y * var1_7.y, 0)

	if not arg0_7.items[arg1_7.position.x] then
		arg0_7.items[arg1_7.position.x] = {}
	end

	arg0_7.items[arg1_7.position.x][arg1_7.position.y] = var0_7
end

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	if not arg0_8.isInited then
		return
	end

	arg0_8.items[arg1_8.x][arg1_8.y]:GetComponent(typeof(Image)).color = arg2_8 and var2_0 or var1_0
end

function var0_0.OnDestroy(arg0_9)
	arg0_9.exited = true
end

return var0_0
