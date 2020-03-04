// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDev/02Gradient"
{

	Properties
	{
		_Color("Main Color",Color) = (1,1,1,1)
		
		_MainTex("Main Texture",2D) = "white" {}
	}

	SubShader
	{
		Tags{"Queue"="Transparent" "IgnoreProjector"="False" "RenderType" = "Transparent" }
		/*Based on Unity's recommendation, Z-Write is turned off for transparent/translucent objects 
		which means render queue plays an important role in rendering non-opaque objects but yes,
		for opaque objects, when Z-Write is turned on, Z-sorting will be the deciding factor.*/
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			//http://docs.unity3d.com/Manual/SL-ShaderPrograms.html
			#pragma vertex vert
			#pragma fragment frag

			uniform half4 _Color; // uniform is global variable 
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST; // float4 because first two floats for tilling and second two for offsetting

			struct vertexInput
			{
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;  // zero is a uv set we can have more than one 
			};
			struct vertexOutput
			{
				float4 pos :SV_POSITION;
				float4 texcoord : TEXCOORD0;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);// becuse rasterizer accepts the data  in projection space
				o.texcoord.xy = (v.texcoord.xy* _MainTex_ST.xy+_MainTex_ST.zw);
				// multibly to extend the range , add to shift the range 
				return o;
			}

			half4 frag(vertexOutput i):COLOR // the half 4 will be treated as color 
			{
				float4 col = tex2D(_MainTex, i.texcoord) *_Color;
				col.a = i.texcoord.x;
				return col;
			}

		ENDCG

		}

	}


}