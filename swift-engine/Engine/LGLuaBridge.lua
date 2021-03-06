--[[
	LGLuaBridge
	This script initializes a new Lua-side scene for scripting.
	It should be run before a scene needs to use Lua.
--]]

-- MARK: Scene singleton

scene = {}
scene.mt = {}
setmetatable(scene, scene.mt)

function scene.mt.__index(table, key)
	local i = key

	if type(i) == "string" then
		i = game.getEntityId(i)
	end

	if i ~= nil then
		table[key] = Entity:new(i)

		if key ~= i then
			table[i] = table[key]
		end

		return table[key]
	end

	return nil
end

-- MARK: Entity class

Entity = {}
Entity.mt = {}
setmetatable(Entity, Entity.mt)

function Entity:new(i)
	local o = { id = i }
	setmetatable(o, Entity.mt)
	return o
end

function Entity.mt.__index(table, key)
	table[key] = Component:new(table.id, key)
	return table[key]
end

-- MARK: Component class

Component = {}
Component.mt = {}
setmetatable(Component, Component.mt)

function Component:new(e, t)
	local o = { entity = e, type = t }
	setmetatable(o, Component.mt)
	return o
end

function Component.mt.__index(table, key)
	return game.getProp(table.entity, table.type, key)
end

function Component.mt.__newindex(table, key, value)
	game.setProp(table.entity, table.type, key, value)
end
