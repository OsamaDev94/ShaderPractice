// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"ShaderPractice/02Gradient"{
Properties{
	_Color ("Main Color", Color)=(1,1,1,1)
    _MainText("Main Texture", 2D) ="white" {} 

}
SubShader{
	Tags{"Queue" ="Transparent" "IgnoreProjector" = "True" "RenderType"="Transparent" }

	Pass {
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#pragma vertex vert 
		#pragma fragment frag

		uniform half4 _Color;
        uniform sampler2D _MainText;
        uniform float4 _MainText_ST;

		struct vertexInput{
			float4 vertex : POSITION;
            float4 texCord : TEXCOORD0;
		};

		struct vertexOutput {
			float4 pos : SV_POSITION;
            float4 texCord : TEXCOORD0;
		};

		vertexOutput vert (vertexInput v){
			vertexOutput o;
			o.pos=UnityObjectToClipPos(v.vertex);
            o.texCord.xy=(v.texCord.xy*_MainText_ST.xy+_MainText_ST.zw);
			return o;
		}	

		half4 frag (vertexOutput i ): Color{
			float4 col = tex2D(_MainText,i.texCord)*_Color;
			col.a=i.texCord.x;
			return col;
		}

		ENDCG
	}
}
}
