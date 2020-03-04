// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderDev/BareBone"
{

	Properties
	{
		_Color("Main Color",Color) = (1,1,1,1)
	}

	SubShader
	{
		Tags{"Queue"="Transparent" "IgnoreProjector"="True" "RenderType" = "Transparent" }
		/*Based on Unity's recommendation, Z-Write is turned off for transparent/translucent objects 
		which means render queue plays an important role in rendering non-opaque objects but yes,
		for opaque objects, when Z-Write is turned on, Z-sorting will be the deciding factor.*/
		Pass
		{

			CGPROGRAM
			//http://docs.unity3d.com/Manual/SL-ShaderPrograms.html
			#pragma vertex vert
			#pragma fragment frag

			uniform half4 _Color; // uniform is global variable 

			struct vertexInput
			{
				float4 vertex : POSITION;
			};
			struct vertexOutput
			{
				float4 pos :SV_POSITION;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);// becuse rasterizer accepts the data  in projection space
				return o;
			}

			half4 frag(vertexOutput i):COLOR // the hal_f 4 will be treated as color 
			{
				return _Color;
			}

		ENDCG

		}

	}


}