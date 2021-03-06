﻿Shader "ShaderDev/09FlagVertAnim"
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_Frequancy("Frequancy" , float)=1
		_Amplitude("Amplitude" , float)=1
		_Speed("Speed" , float)=1
		
	}
	
	Subshader
	{
		//http://docs.unity3d.com/462/Documentation/Manual/SL-SubshaderTags.html
	    // Background : 1000     -        0 - 1499 = Background
        // Geometry   : 2000     -     1500 - 2399 = Geometry
        // AlphaTest  : 2450     -     2400 - 2699 = AlphaTest
        // Transparent: 3000     -     2700 - 3599 = Transparent
        // Overlay    : 4000     -     3600 - 5000 = Overlay
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			//http://docs.unity3d.com/Manual/SL-ShaderPrograms.html
			#pragma vertex vert
			#pragma fragment frag
			
			//http://docs.unity3d.com/ru/current/Manual/SL-ShaderPerformance.html
			//http://docs.unity3d.com/Manual/SL-ShaderPerformance.html
			uniform half4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _Frequancy;
			uniform float _Amplitude;
			uniform float _Speed;

		
			//https://msdn.microsoft.com/en-us/library/windows/desktop/bb509647%28v=vs.85%29.aspx#VS
			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct vertexOutput
			{
				float4 pos : SV_POSITION;
				float4 texcoord : TEXCOORD0; 
			};
			
			float4 vertFlagAnim(float4 vertPos , float2 uv){
				vertPos.z = vertPos.z + sin((uv.x - (_Time.y*_Speed))*_Frequancy)*(uv.x*_Amplitude);
				return vertPos;
			}

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;UNITY_INITIALIZE_OUTPUT(vertexOutput, o); // d3d11 requires initialization
				v.vertex= vertFlagAnim(v.vertex, v.texcoord);
				o.pos = UnityObjectToClipPos( v.vertex);
				o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return o;
			}
			
			

			half4 frag(vertexOutput i) : COLOR
			{
				float4 col = tex2D(_MainTex, i.texcoord) * _Color;
				//col.a = drawCircleAnimate(i.texcoord ,_Center, _Radius,_Feather , _Speed) ;
				return col;
			}

			ENDCG
		}
	}
}