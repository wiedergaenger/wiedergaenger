package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_34_34_DetectPlayer extends ActorScript
{
	public var _targetActor:Actor;
	public var _maxRange:Float;
	public var _minRange:Float;
	public var _animationLeft:String;
	public var _animationRight:String;
	public var _animationIdle:String;
	public var _isIdle:Bool;
	public var _isShooting:Bool;
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_isWithinRange():Bool
	{
		var __Self:Actor = actor;
		return ((cast(actor.say("Detect Player", "_customBlock_eucledianDistance"), Float) >= _minRange) && (cast(actor.say("Detect Player", "_customBlock_eucledianDistance"), Float) <= _maxRange));
	}
	
	/* ========================= Custom Block ========================= */
	public function _customBlock_eucledianDistance():Float
	{
		var __Self:Actor = actor;
		return Math.abs(Math.sqrt((Math.pow((_targetActor.getX() - actor.getX()), 2) + Math.pow((_targetActor.getY() - actor.getY()), 2))));
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("targetActor", "_targetActor");
		nameMap.set("maxRange", "_maxRange");
		_maxRange = 0.0;
		nameMap.set("minRange", "_minRange");
		_minRange = 0.0;
		nameMap.set("animationLeft", "_animationLeft");
		nameMap.set("animationRight", "_animationRight");
		nameMap.set("animationIdle", "_animationIdle");
		nameMap.set("isIdle", "_isIdle");
		_isIdle = true;
		nameMap.set("isShooting", "_isShooting");
		_isShooting = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		actor.setAnimation("" + _animationIdle);
		_isIdle = true;
		propertyChanged("_isIdle", _isIdle);
		actor.disableBehavior("Enemy Walking AI");
		if(_isShooting)
		{
			actor.disableBehavior("Enhanced FiringLoop");
		}
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(cast(actor.say("Detect Player", "_customBlock_isWithinRange"), Bool))
				{
					if(_isIdle)
					{
						_isIdle = false;
						propertyChanged("_isIdle", _isIdle);
						actor.enableBehavior("Enemy Walking AI");
						if(_isShooting)
						{
							actor.enableBehavior("Enhanced FiringLoop");
						}
					}
					else
					{
						_isIdle = true;
						propertyChanged("_isIdle", _isIdle);
						actor.disableBehavior("Enemy Walking AI");
						if(_isShooting)
						{
							actor.disableBehavior("Enhanced FiringLoop");
						}
					}
					if((_targetActor.getX() > actor.getX()))
					{
						actor.setAnimation("" + _animationRight);
					}
					else
					{
						actor.setAnimation("" + _animationLeft);
					}
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}