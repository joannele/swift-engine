//
//  LGScriptable.swift
//  swift-engine
//
//  Created by Luke Godfrey on 10/2/14.
//  Copyright (c) 2014 Luke Godfrey. See LICENSE.
//

public final class LGScriptable: LGComponent
{
	public class func type() -> String
	{
		return "LGScriptable"
	}
	
	public func type() -> String
	{
		return LGScriptable.type()
	}
	
	public var scripts = [String:String]()
	public var events = [Event]()
	
	// For script vars
	public var props = [String:LGJSON]()
	
	public init() {}
	
	public struct Event
	{
		public var name: String
		public var params: [AnyObject]?
		
		public init(name: String, params: [AnyObject]?)
		{
			self.name = name
			self.params = params
		}
		
		public init(name: String)
		{
			self.name = name
			self.params = nil
		}
	}
}

extension LGScriptable: LGDeserializable
{
	public class var requiredProps: [String]
	{
		return []
	}
	
	public class var optionalProps: [String]
	{
		return [ "scripts" ]
	}
	
	public class func instantiate() -> LGDeserializable
	{
		return LGScriptable()
	}
	
	public func setValue(value: LGJSON, forKey key: String) -> Bool
	{
		switch key
		{
			case "scripts":
				for (k, v) in value
				{
					scripts[k] = v.stringValue
				}
			
			case "nextEvent":
				if let val = value.stringValue
				{
					events.append(Event(name: val, params: nil))
				}
			
			default:
				props[key] = value
		}
		
		return true
	}
	
	public func valueForKey(key: String) -> LGJSON
	{
		if let val = props[key]
		{
			return val
		}
		
		return LGJSON(value: nil)
	}
}
