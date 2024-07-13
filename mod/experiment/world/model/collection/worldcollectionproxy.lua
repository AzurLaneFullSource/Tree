local var0_0 = class("WorldCollectionProxy", import("....BaseEntity"))

var0_0.Fields = {
	storyGroup = "table",
	data = "table",
	placeGroup = "table"
}
var0_0.EventPlaceUnlock = "WorldCollectionProxy.EventPlaceUnlock"
var0_0.WorldCollectionType = {
	FILE = 1,
	RECORD = 2
}
var0_0.WorldCollectionTemplate = {}
var0_0.WorldCollectionTemplateExtend = {}

for iter0_0, iter1_0 in ipairs(pg.world_collection_file_template.all) do
	local var1_0 = pg.world_collection_file_template[iter1_0]

	if var0_0.WorldCollectionTemplate[iter1_0] ~= nil then
		assert(false, "Repeat Collection UID " .. iter1_0)
	end

	var0_0.WorldCollectionTemplate[iter1_0] = var1_0
	var0_0.WorldCollectionTemplateExtend[iter1_0] = var0_0.WorldCollectionTemplateExtend[iter1_0] or {}
	var0_0.WorldCollectionTemplateExtend[iter1_0].type = var0_0.WorldCollectionType.FILE
end

for iter2_0, iter3_0 in ipairs(pg.world_collection_file_group.all) do
	local var2_0 = pg.world_collection_file_group[iter3_0]

	for iter4_0, iter5_0 in ipairs(var2_0.child) do
		if var0_0.WorldCollectionTemplate[iter5_0] ~= nil then
			var0_0.WorldCollectionTemplateExtend[iter5_0].group = var2_0.id
		else
			assert(false, "Missing Collection FILE UID " .. iter5_0)
		end
	end
end

for iter6_0, iter7_0 in ipairs(pg.world_collection_record_template.all) do
	local var3_0 = pg.world_collection_record_template[iter7_0]

	if var0_0.WorldCollectionTemplate[iter7_0] ~= nil then
		assert(false, "Repeat Collection UID " .. iter7_0)
	end

	var0_0.WorldCollectionTemplate[iter7_0] = var3_0
	var0_0.WorldCollectionTemplateExtend[iter7_0] = var0_0.WorldCollectionTemplateExtend[iter7_0] or {}
	var0_0.WorldCollectionTemplateExtend[iter7_0].type = var0_0.WorldCollectionType.RECORD
end

for iter8_0, iter9_0 in ipairs(pg.world_collection_record_group.all) do
	local var4_0 = pg.world_collection_record_group[iter9_0]

	for iter10_0, iter11_0 in ipairs(var4_0.child) do
		if var0_0.WorldCollectionTemplate[iter11_0] ~= nil then
			var0_0.WorldCollectionTemplateExtend[iter11_0].group = var4_0.id
		else
			assert(false, "Missing Collection RECORD UID " .. iter11_0)
		end
	end
end

function var0_0.GetCollectionTemplate(arg0_1)
	local var0_1 = var0_0.WorldCollectionTemplate[arg0_1]

	assert(var0_1, "Missing WorldCollection Config ID: " .. (arg0_1 or "NIL"))

	return var0_1
end

function var0_0.GetCollectionType(arg0_2)
	local var0_2 = var0_0.WorldCollectionTemplateExtend[arg0_2]

	assert(var0_2 and var0_2.type, "Missing WorldCollection Type ID: " .. (arg0_2 or "NIL"))

	return var0_2.type
end

function var0_0.GetCollectionGroup(arg0_3)
	local var0_3 = var0_0.WorldCollectionTemplateExtend[arg0_3]

	assert(var0_3 and var0_3.group, "Missing WorldCollection Type ID: " .. (arg0_3 or "NIL"))

	return var0_3.group
end

function var0_0.GetCollectionFileGroupTemplate(arg0_4)
	local var0_4 = pg.world_collection_file_group[arg0_4]

	assert(var0_4, "Missing world_collection_file_group Config ID: " .. (arg0_4 or "NIL"))

	return var0_4
end

function var0_0.GetCollectionFileTemplate(arg0_5)
	local var0_5 = pg.world_collection_file_template[arg0_5]

	assert(var0_5, "Missing world_collection_file_template Config ID: " .. (arg0_5 or "NIL"))

	return var0_5
end

function var0_0.GetCollectionRecordGroupTemplate(arg0_6)
	local var0_6 = pg.world_collection_record_group[arg0_6]

	assert(var0_6, "Missing world_collection_record_group Config ID: " .. (arg0_6 or "NIL"))

	return var0_6
end

function var0_0.GetCollectionRecordTemplate(arg0_7)
	local var0_7 = pg.world_collection_record_template[arg0_7]

	assert(var0_7, "Missing world_collection_record_template Config ID: " .. (arg0_7 or "NIL"))

	return var0_7
end

function var0_0.Setup(arg0_8, arg1_8)
	arg0_8.data = {}

	for iter0_8, iter1_8 in ipairs(arg1_8) do
		arg0_8.data[iter1_8] = true
	end
end

function var0_0.Unlock(arg0_9, arg1_9)
	if not arg0_9.data[arg1_9] then
		arg0_9.data[arg1_9] = true
	end
end

function var0_0.IsUnlock(arg0_10, arg1_10)
	return tobool(arg0_10.data[arg1_10])
end

return var0_0
